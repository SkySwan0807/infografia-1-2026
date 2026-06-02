# Jugador top-down (demo completo).
#
# Es el MISMO movimiento de la sesión 2 (CharacterBody2D + move_and_slide):
# acá no aprendemos a mover, ya sabemos. Lo nuevo de esta sesión es el MUNDO
# por el que camina (el TileMapLayer) y cómo choca con sus paredes.
#
# La colisión con el tilemap es automática: el jugador está en la capa "jugador"
# y su mask incluye "mundo"; los tiles con polígono de colisión están en "mundo".

extends CharacterBody2D

@export var velocidad: float = 60.0

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")

	velocity = direccion.normalized() * velocidad
	move_and_slide()
