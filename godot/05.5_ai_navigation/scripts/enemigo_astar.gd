# SESIÓN B · escena 04 — SEGUIR EL CAMINO (A* sobre la grilla).  ✅ demo
#
# Ya tenemos la grilla (escena 03). Ahora le pedimos a A* el CAMINO de celdas
# entre el enemigo y el jugador, y lo seguimos celda por celda reusando el mismo
# "ir hacia" de la sesión A.
#
#   _cel(pos)   : de una posición en píxeles -> a qué celda cae (local_to_map).
#   _mundo(cel) : de una celda -> al centro de esa celda en píxeles (map_to_local).
#   get_id_path(ini, fin) : la lista de celdas del camino más corto.
#
# Seguir el camino = apuntar al siguiente punto; cuando lo piso, avanzo al que
# sigue. El enemigo ya NO se traba: rodea el muro.
#
# NOTA: acá recalculamos el camino TODOS los frames (60 veces/seg). Funciona,
# pero es un derroche. La escena 05 lo arregla recalculando cada tanto.

extends CharacterBody2D

@export var player_path: NodePath
@export var paredes_path: NodePath
@export var max_speed: float = 65.0
@export var diagonales: bool = false   # probá ponerlo en true y mirá cómo cambia el camino

const TILE := 16

var astar := AStarGrid2D.new()
var player: Node2D
var paredes: TileMapLayer
var _camino: PackedVector2Array = PackedVector2Array()
var _idx := 0


func _ready() -> void:
	player = get_node_or_null(player_path)
	paredes = get_node(paredes_path)
	call_deferred("_construir_grilla")


func _construir_grilla() -> void:
	var usado := paredes.get_used_rect()
	astar.region = Rect2i(Vector2i.ZERO, usado.position + usado.size)
	astar.cell_size = Vector2(TILE, TILE)
	astar.diagonal_mode = (AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
		if diagonales else AStarGrid2D.DIAGONAL_MODE_NEVER)
	astar.update()
	for celda in paredes.get_used_cells():
		if astar.is_in_boundsv(celda):
			astar.set_point_solid(celda, true)


func _cel(pos: Vector2) -> Vector2i:
	return paredes.local_to_map(paredes.to_local(pos))


func _mundo(celda: Vector2i) -> Vector2:
	return paredes.to_global(paredes.map_to_local(celda))


func _recalcular() -> void:
	if player == null or astar.region.size == Vector2i.ZERO:
		return
	var ini := _cel(global_position)
	var fin := _cel(player.global_position)
	if not astar.is_in_boundsv(ini) or not astar.is_in_boundsv(fin):
		return
	if astar.is_point_solid(fin):
		return   # el jugador está sobre una pared: no hay camino
	# get_id_path -> celdas; las pasamos a píxeles (centro de cada celda)
	var celdas := astar.get_id_path(ini, fin)
	_camino = PackedVector2Array()
	for c in celdas:
		_camino.append(_mundo(c))
	_idx = 0
	# si el primer punto es la celda donde ya estoy, lo salto
	if _camino.size() > 1 and global_position.distance_to(_camino[0]) < TILE * 0.5:
		_idx = 1


func _physics_process(_delta: float) -> void:
	_recalcular()   # naive: cada frame (la escena 05 lo arregla)
	if _idx < _camino.size():
		var objetivo := _camino[_idx]
		if global_position.distance_to(objetivo) < 3.0:
			_idx += 1
		else:
			velocity = global_position.direction_to(objetivo) * max_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	queue_redraw()


# dibuja el camino que calculó A* (en coordenadas locales al enemigo)
func _draw() -> void:
	for i in range(_idx, _camino.size()):
		var p := to_local(_camino[i])
		draw_circle(p, 2.0, Color(0.4, 0.8, 1.0, 0.9))
		if i + 1 < _camino.size():
			draw_line(p, to_local(_camino[i + 1]), Color(0.4, 0.8, 1.0, 0.6), 1.0)
