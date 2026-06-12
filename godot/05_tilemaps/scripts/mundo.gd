# Mundo jugable (demo completo) — todo junto.
#
# El "premio" de la sesión: un mundo chico armado por código sobre DOS capas.
#   - Suelo:   pasto + un camino de tierra + un estanque (sin colisión).
#   - Paredes: un cerco que SÍ choca (los tiles de cerco traen su polígono de
#              colisión en el TileSet, en la capa de física "mundo").
# El jugador camina, choca con el cerco y la cámara lo sigue.
#
# Dos capas separadas = dos TileMapLayer hijos. Pintamos cada uno por su lado;
# el orden en el árbol decide qué se dibuja encima (Paredes va después de Suelo).

extends Node2D

@onready var suelo: TileMapLayer = $Suelo
@onready var paredes: TileMapLayer = $Paredes

const ANCHO := 20
const ALTO := 12

# id de fuente dentro de mundo.tres (el orden en que se agregaron las imágenes)
const F_PASTO := 0
const F_TIERRA := 1
const F_CERCO := 2
const F_AGUA := 3

const T_PASTO := Vector2i(1, 5)
const T_TIERRA := Vector2i(1, 5)
const T_CERCO := Vector2i(0, 0)
const T_AGUA := Vector2i(1, 0)

var estado = true

func _ready() -> void:
	_pintar_pasto()
	_pintar_camino()
	_pintar_estanque()
	_pintar_cerco()

func _pintar_pasto() -> void:
	for y in range(ALTO):
		for x in range(ANCHO):
			suelo.set_cell(Vector2i(x, y), F_PASTO, T_PASTO)

func _pintar_camino() -> void:
	# un camino de tierra horizontal que cruza el mapa
	for x in range(ANCHO):
		suelo.set_cell(Vector2i(x, 6), F_TIERRA, T_TIERRA)

func _pintar_estanque() -> void:
	for y in range(2, 4):
		for x in range(13, 17):
			suelo.set_cell(Vector2i(x, y), F_AGUA, T_AGUA)

func _pintar_cerco() -> void:
	# borde superior e inferior
	for x in range(ANCHO):
		paredes.set_cell(Vector2i(x, 0), F_CERCO, T_CERCO)
		paredes.set_cell(Vector2i(x, ALTO - 1), F_CERCO, T_CERCO)
	# bordes laterales
	for y in range(ALTO):
		paredes.set_cell(Vector2i(0, y), F_CERCO, T_CERCO)
		paredes.set_cell(Vector2i(ANCHO - 1, y), F_CERCO, T_CERCO)


func _on_timer_timeout() -> void:
	if estado:
		for y in range(2, 4):
			for x in range(13, 17):
				paredes.set_cell(Vector2i(x, y))
		
		estado = not estado	
	else:
		for y in range(2, 4):
			for x in range(13, 17):
				paredes.set_cell(Vector2i(x, y), F_CERCO, T_CERCO)
				
		estado = not estado
