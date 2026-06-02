# Terrenos / autotile (demo completo) — los bordes se resuelven solos.
#
# Pintar a mano un borde de pasto (esquinas, lados, diagonales) es tedioso y
# fácil de equivocar. Un "terrain set" invierte el problema: vos decís "esta
# zona es PASTO" y Godot elige, casillero por casillero, qué tile de borde va
# en cada lugar mirando a sus vecinos (esa es la idea del bitmask de las slides).
#
# Una sola llamada hace toda la magia:
#   set_cells_terrain_connect(celdas, terrain_set, terrain)
#
# NOTA para el docente: este TileSet trae el terreno "Pasto" con el tile central
# ya cableado, así que corre sin errores. Para ver los BORDES variando, hay que
# asignar los tiles de esquina/lado en el panel TileSet → Terrains (es el
# ejercicio del bitmask). Mientras no estén, el bloque se rellena con el tile
# central y se ve como un rectángulo liso.

extends TileMapLayer

const TERRAIN_SET := 0
const TERRAIN_PASTO := 0

func _ready() -> void:
	var celdas: Array[Vector2i] = []

	# Un bloque rectangular de pasto.
	for y in range(2, 9):
		for x in range(3, 14):
			celdas.append(Vector2i(x, y))

	# Una "isla" más chica al costado, para ver dos zonas separadas.
	for y in range(4, 7):
		for x in range(15, 19):
			celdas.append(Vector2i(x, y))

	set_cells_terrain_connect(celdas, TERRAIN_SET, TERRAIN_PASTO)
