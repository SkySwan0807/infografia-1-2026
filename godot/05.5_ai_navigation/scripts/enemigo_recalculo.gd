# SESIÓN B · escena 05 — RECALCULAR BIEN (throttling).  🔨 placeholder del docente
#
# La escena 04 recalcula el camino 60 veces por segundo. Calcular un A* es caro:
# hacerlo cada frame, para cada enemigo, no escala. Pero si NO recalculás, el
# enemigo persigue una posición vieja del jugador.
#
# La solución: recalcular CADA TANTO (no cada frame). Dos disparadores típicos:
#   - por tiempo: cada `recalcular_cada` segundos.
#   - por celda : solo cuando el jugador CAMBIÓ de celda (lo que se ve abajo).
#
# >>> EN CLASE: completar el bloque TODO de _physics_process para recalcular solo
#     cuando toca. Mientras esté sin completar, recalcula siempre (como la 04).

extends CharacterBody2D

@export var player_path: NodePath
@export var paredes_path: NodePath
@export var max_speed: float = 65.0
@export var recalcular_cada: float = 0.25   # segundos entre recálculos

const TILE := 16

var astar := AStarGrid2D.new()
var player: Node2D
var paredes: TileMapLayer
var _camino: PackedVector2Array = PackedVector2Array()
var _idx := 0
var _acum := 0.0
var _ultima_celda_jugador := Vector2i(9999, 9999)


func _ready() -> void:
	player = get_node_or_null(player_path)
	paredes = get_node(paredes_path)
	call_deferred("_construir_grilla")


func _construir_grilla() -> void:
	var usado := paredes.get_used_rect()
	astar.region = Rect2i(Vector2i.ZERO, usado.position + usado.size)
	astar.cell_size = Vector2(TILE, TILE)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	for celda in paredes.get_used_cells():
		if astar.is_in_boundsv(celda):
			astar.set_point_solid(celda, true)


func _cel(pos: Vector2) -> Vector2i:
	return paredes.local_to_map(paredes.to_local(pos))


func _mundo(celda: Vector2i) -> Vector2:
	return paredes.to_global(paredes.map_to_local(celda))


func _recalcular() -> void:
	print("recalculando trayectoria...")
	if player == null or astar.region.size == Vector2i.ZERO:
		return
	var ini := _cel(global_position)
	var fin := _cel(player.global_position)
	if not astar.is_in_boundsv(ini) or not astar.is_in_boundsv(fin):
		return
	if astar.is_point_solid(fin):
		return
	var celdas := astar.get_id_path(ini, fin)
	_camino = PackedVector2Array()
	for c in celdas:
		_camino.append(_mundo(c))
	_idx = 0
	if _camino.size() > 1 and global_position.distance_to(_camino[0]) < TILE * 0.5:
		_idx = 1


func _physics_process(delta: float) -> void:
	# ----------------------------------------------------------------------
	# TODO (en clase): recalcular SOLO cuando haga falta, no cada frame.
	# Solución sugerida (descomentar y borrar el _recalcular() de abajo):
	#
	#   _acum += delta
	#   var celda_jugador := _cel(player.global_position)
	#   if _acum >= recalcular_cada or celda_jugador != _ultima_celda_jugador:
	#       _acum = 0.0
	#       _ultima_celda_jugador = celda_jugador
	#       _recalcular()
	# ----------------------------------------------------------------------
	_acum += delta
	print(_acum)
	var celda_jugador = _cel(player.global_position)
	if _acum >= recalcular_cada or celda_jugador != _ultima_celda_jugador:
		_acum = 0.0
		_ultima_celda_jugador = celda_jugador
		_recalcular()

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


func _draw() -> void:
	for i in range(_idx, _camino.size()):
		var p := to_local(_camino[i])
		draw_circle(p, 2.0, Color(0.4, 0.8, 1.0, 0.9))
		if i + 1 < _camino.size():
			draw_line(p, to_local(_camino[i + 1]), Color(0.4, 0.8, 1.0, 0.6), 1.0)
