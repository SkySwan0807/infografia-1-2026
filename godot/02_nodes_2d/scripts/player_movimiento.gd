# Movimiento top-down 8-direccional (demo completo).
#
# Concepto clave: leemos dos ejes (horizontal y vertical) y armamos un
# Vector2 de direccion. .normalized() evita que moverse en diagonal sea
# mas rapido (factor sqrt(2) ~ 1.41) que moverse en linea recta.
#
# correr: F6 sobre scenes/01_movimiento.tscn

extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(_delta: float) -> void:
	# cada eje devuelve -1, 0 o +1
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")

	# sin esto, la diagonal mide sqrt(2) y el jugador va mas rapido en diagonal
	direccion = direccion.normalized()

	velocity = direccion * speed
	move_and_slide()
