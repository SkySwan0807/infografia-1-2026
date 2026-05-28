# Fantasma del demo 04: deambula horizontalmente, gira al chocar contra
# una pared. Comportamiento minimo a proposito: el centro de la clase
# NO es este script, es el toggle de capas en el Inspector.
#
# Configuracion de capas que importa (en la escena):
#   collision_layer = 2  (jugador)
#   collision_mask  = 1 + 4 = 5  (mundo + muro)
#
# El "aha": destildar el bit "muro" del mask en el Inspector ->
# el fantasma sigue acotado por mundo (piso + paredes externas)
# pero atraviesa los pilares interiores.

extends CharacterBody2D

const VELOCIDAD: float = 140.0
const GRAVEDAD: float = 1200.0

var direccion_x: float = -1.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta
	velocity.x = direccion_x * VELOCIDAD
	move_and_slide()
	if is_on_wall():
		direccion_x = -direccion_x
