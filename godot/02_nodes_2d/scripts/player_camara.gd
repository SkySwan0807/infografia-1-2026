# Movimiento + camara que sigue al jugador (demo completo).
#
# Concepto clave: una Camera2D que es HIJA del Player sigue su posicion
# automaticamente, sin escribir codigo de camara. El movimiento es el mismo
# de 01_movimiento; lo unico nuevo es el nodo Camera2D en el arbol.
#
# correr: F6 sobre scenes/03_camara.tscn

extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	velocity = direccion * speed
	move_and_slide()
