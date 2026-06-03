# Jugador top-down (demo completo).
#
# Es el MISMO movimiento de la sesión 2 (CharacterBody2D + move_and_slide). Acá
# no aprendemos a mover: ya sabemos. El jugador es solo el "objetivo" que la IA
# enemiga tiene que alcanzar. Lo movés con WASD/flechas para ver cómo el enemigo
# recalcula su camino en tiempo real.

extends CharacterBody2D

@export var velocidad: float = 70.0

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")

	velocity = direccion.normalized() * velocidad
	move_and_slide()
