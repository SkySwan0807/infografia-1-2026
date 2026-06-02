# Relleno de pasto (demo completo) — el "Hola mundo" de pintar por código.
#
# Va sobre un TileMapLayer. En _ready() recorre una grilla de ANCHO x ALTO
# celdas y pone en cada una el mismo tile de pasto. Una sola idea:
#
#   set_cell(coordenada_de_celda, id_de_fuente, coordenada_en_el_atlas)
#
# - coordenada_de_celda: en qué casillero del mundo (Vector2i en celdas, no px).
# - id_de_fuente: qué imagen del TileSet (0 = la primera fuente).
# - coordenada_en_el_atlas: qué tile dentro de esa imagen (fila/columna).

extends TileMapLayer

const ANCHO := 20
const ALTO := 11
const FUENTE_PASTO := 0
const TILE_PASTO := Vector2i(1, 5)  # casillero de pasto liso en Grass.png

func _ready() -> void:
	for y in range(ALTO):
		for x in range(ANCHO):
			set_cell(Vector2i(x, y), FUENTE_PASTO, TILE_PASTO)
