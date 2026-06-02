# Mapa con agua (demo completo) — el escenario del ejercicio 05.
#
# Pinta un campo de pasto con un estanque de agua en el medio. No tiene nada
# nuevo respecto de los otros pintores; está acá solo para darle al ejercicio
# `leer_mapa.gd` un mundo con DOS tipos de terreno que leer (suelo vs agua).
#
# El TileSet `datos.tres` le pone a cada tile un dato custom "tipo"
# ("suelo" o "agua"). Ese dato es lo que el jugador va a leer en el ejercicio.

extends TileMapLayer

const ANCHO := 20
const ALTO := 12
const F_PASTO := 0
const F_AGUA := 1
const T_PASTO := Vector2i(1, 5)
const T_AGUA := Vector2i(1, 0)

func _ready() -> void:
	for y in range(ALTO):
		for x in range(ANCHO):
			set_cell(Vector2i(x, y), F_PASTO, T_PASTO)

	# un estanque rectangular en el centro
	for y in range(4, 8):
		for x in range(7, 13):
			set_cell(Vector2i(x, y), F_AGUA, T_AGUA)
