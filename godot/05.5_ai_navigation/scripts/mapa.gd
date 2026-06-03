# El MUNDO (demo completo) — pintado por código sobre dos capas.
#
# Es el mismo patrón de la sesión 5 (TileMapLayer + set_cell): un mapa es una
# tabla de celdas. Acá lo importante no es el dibujo, es que este mapa es el
# DATO sobre el que la IA va a navegar:
#
#   - Paredes : tiles de cerco CON colisión. Son los obstáculos. La IA los va a
#               leer con paredes.get_used_cells() para saber qué celdas bloquear.
#   - Suelo   : pasto (costo 1) y "barro"/agua (costo 5). Cada tile lleva un dato
#               custom "costo" que la IA usará para preferir el pasto y rodear el barro.
#
# La escena se instancia dentro de cada lección; el enemigo recibe por NodePath
# las capas Suelo y Paredes y construye su navegación a partir de ellas.

extends Node2D

@onready var suelo: TileMapLayer = $Suelo
@onready var paredes: TileMapLayer = $Paredes

const ANCHO := 20
const ALTO := 12

# id de fuente dentro de mundo_nav.tres (orden en que se agregaron las imágenes)
const F_PASTO := 0
const F_TIERRA := 1
const F_CERCO := 2
const F_AGUA := 3

const T_PASTO := Vector2i(1, 5)
const T_TIERRA := Vector2i(1, 5)
const T_CERCO := Vector2i(0, 0)
const T_AGUA := Vector2i(0, 0)


func _ready() -> void:
	_construir()


func _construir() -> void:
	var muros := celdas_pared()
	var barro := celdas_barro()
	for y in ALTO:
		for x in ANCHO:
			var c := Vector2i(x, y)
			if muros.has(c):
				# las paredes NO llevan suelo debajo: así la celda queda "hueca"
				paredes.set_cell(c, F_CERCO, T_CERCO)
			elif barro.has(c):
				suelo.set_cell(c, F_AGUA, T_AGUA)   # caminable, pero caro (costo 5)
			else:
				suelo.set_cell(c, F_PASTO, T_PASTO)


# Las celdas que son pared. Un borde cerrado + un muro divisor (mitad superior,
# con paso abajo) + un par de pilares. Suficiente para que el camino recto NO
# sirva y haya que rodear.
func celdas_pared() -> Dictionary:
	var s := {}
	for x in ANCHO:
		s[Vector2i(x, 0)] = true
		s[Vector2i(x, ALTO - 1)] = true
	for y in ALTO:
		s[Vector2i(0, y)] = true
		s[Vector2i(ANCHO - 1, y)] = true
	# muro divisor vertical: ocupa la mitad de arriba (y 1..6), deja paso por abajo
	for y in range(1, 7):
		s[Vector2i(10, y)] = true
	# pilares sueltos
	s[Vector2i(4, 3)] = true
	s[Vector2i(15, 8)] = true
	return s


# Un charco de barro en la zona abierta de abajo. El camino recto del enemigo al
# jugador lo cruza; con pesos por terreno la IA prefiere rodearlo por el pasto.
func celdas_barro() -> Dictionary:
	var s := {}
	for y in range(8, 10):
		for x in range(5, 9):
			s[Vector2i(x, y)] = true
	return s
