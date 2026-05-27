# ejercicio 1: correr (sprint) — SOLUCION.

extends CharacterBody2D

@export var speed: float = 200.0
@export var speed_corriendo: float = 400.0

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	var velocidad_actual := speed
	if Input.is_action_pressed("correr"):
		velocidad_actual = speed_corriendo

	velocity = direccion * velocidad_actual
	move_and_slide()
