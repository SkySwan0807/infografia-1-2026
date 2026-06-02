# Mapa por código (demo completo) — un mapa ES datos.
#
# La idea clave de la sesión: un nivel no tiene por qué pintarse a mano. Un
# TileMapLayer es una grilla, y una grilla es un array 2D. Acá el mapa vive como
# una tabla de números (MAPA) y un diccionario que traduce cada número a un tile
# del atlas (TILES). Cambiar el nivel = cambiar números.
#
# Esto es lo que hacen los generadores de niveles, los editores propios y los
# juegos procedurales: separan el DATO (qué hay) de la IMAGEN (cómo se ve).

extends TileMapLayer

const FUENTE := 0

# Cada número del mapa apunta a un casillero del atlas (Grass.png).
const TILES := {
	0: Vector2i(1, 5),  # pasto liso
	1: Vector2i(2, 5),  # pasto, otra variante
	2: Vector2i(0, 0),  # arbusto (decoración)
}

# El nivel, leído como se ve: cada fila es una fila de la pantalla.
const MAPA := [
	[2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
	[0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
	[0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
	[2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
]

func _ready() -> void:
	for y in MAPA.size():
		var fila: Array = MAPA[y]
		for x in fila.size():
			var numero: int = fila[x]
			set_cell(Vector2i(x, y), FUENTE, TILES[numero])
