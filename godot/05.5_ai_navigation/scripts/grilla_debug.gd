# SESIÓN B · escena 03 — LA GRILLA: el tilemap se vuelve dato de navegación.  ✅ demo
#
# Esta es la idea central de "navegación con tilemaps": un AStarGrid2D es una
# grilla de celdas que sabe cuáles están BLOQUEADAS. ¿De dónde sale esa info?
# Del propio TileMapLayer de paredes. No duplicamos nada:
#
#   1. region    = de qué celda a qué celda existe la grilla (todo el mapa).
#   2. cell_size = cuánto mide una celda en píxeles (16, como el tile).
#   3. update()  = construye la grilla.
#   4. por cada celda pintada en "Paredes" -> set_point_solid(celda, true).
#
# No hay movimiento todavía: solo DIBUJAMOS la grilla encima del mundo para VER
# qué entendió el A*. Rojo = celda bloqueada (hay pared). Azul tenue = libre.

extends Node2D

@export var paredes_path: NodePath

const TILE := 16

var astar := AStarGrid2D.new()
var paredes: TileMapLayer


func _ready() -> void:
	paredes = get_node(paredes_path)
	# el mapa se pinta en el _ready del escenario; construimos la grilla diferido
	# para asegurarnos de que las paredes ya estén pintadas.
	call_deferred("_construir_grilla")


func _construir_grilla() -> void:
	var usado := paredes.get_used_rect()
	astar.region = Rect2i(Vector2i.ZERO, usado.position + usado.size)
	astar.cell_size = Vector2(TILE, TILE)
	astar.update()

	# cada celda pintada en Paredes = un obstáculo para el A*
	for celda in paredes.get_used_cells():
		if astar.is_in_boundsv(celda):
			astar.set_point_solid(celda, true)

	queue_redraw()


func _draw() -> void:
	if astar.region.size == Vector2i.ZERO:
		return
	for y in astar.region.size.y:
		for x in astar.region.size.x:
			var c := Vector2i(x, y)
			var r := Rect2(Vector2(x * TILE, y * TILE), Vector2(TILE, TILE))
			if astar.is_point_solid(c):
				draw_rect(r, Color(0.95, 0.2, 0.3, 0.45))         # bloqueada
			else:
				draw_rect(r, Color(0.4, 0.7, 1.0, 0.10))          # libre
			draw_rect(r, Color(0.5, 0.5, 0.6, 0.25), false, 1.0)  # reja de la grilla
