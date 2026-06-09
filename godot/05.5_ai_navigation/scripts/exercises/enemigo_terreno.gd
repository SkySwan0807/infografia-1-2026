# SESIÓN B · escena 06 — TERRENO CON COSTO (peso por celda).  🎓 ejercicio
#
# Hasta ahora todas las celdas libres "cuestan" lo mismo, así que A* busca el
# camino más CORTO. Pero no todo el suelo es igual: cruzar barro debería costar
# más que ir por el pasto. AStarGrid2D permite ponerle un PESO a cada celda con
# set_point_weight_scale(celda, peso): A* prefiere el camino más BARATO, no el más corto.
#
# ¿De dónde sale el peso? Del tile: en mundo_nav.tres cada tile de suelo lleva un
# dato custom "costo" (pasto = 1.0, barro/agua = 5.0). Es exactamente "leer el
# mapa" de la sesión 5, ahora usado para navegar.
#
# 🎓 TU TURNO: completá los 3 TODO de _pesos_por_terreno(). Meta visual: el
#    enemigo deja de cruzar el charco y lo rodea por el pasto.
#    (Solución en la carpeta _solutions/, solo del docente.)

extends CharacterBody2D

@export var player_path: NodePath
@export var paredes_path: NodePath
@export var suelo_path: NodePath
@export var max_speed: float = 65.0

const TILE := 16

var astar := AStarGrid2D.new()
var player: Node2D
var paredes: TileMapLayer
var suelo: TileMapLayer
var _camino: PackedVector2Array = PackedVector2Array()
var _idx := 0


func _ready() -> void:
	player = get_node_or_null(player_path)
	paredes = get_node(paredes_path)
	suelo = get_node(suelo_path)
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
	_pesos_por_terreno()


# Recorre todas las celdas y le pone a cada una el peso que dice su tile de suelo.
func _pesos_por_terreno() -> void:
	for y in astar.region.size.y:
		for x in astar.region.size.x:
			var celda := Vector2i(x, y)
			if astar.is_point_solid(celda):
				continue
			# TODO 1: pedir los datos del tile de suelo en esta celda.
			var datos := suelo.get_cell_tile_data(celda)

			# TODO 2: si hay datos, leer el costo del custom data "costo".
			var costo = datos.get_custom_data("costo")

			# TODO 3: aplicar ese costo como peso de la celda.
			astar.set_point_weight_scale(celda, costo)
			


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
		return
	var celdas := astar.get_id_path(ini, fin)
	_camino = PackedVector2Array()
	for c in celdas:
		_camino.append(_mundo(c))
	_idx = 0
	if _camino.size() > 1 and global_position.distance_to(_camino[0]) < TILE * 0.5:
		_idx = 1


func _physics_process(_delta: float) -> void:
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
