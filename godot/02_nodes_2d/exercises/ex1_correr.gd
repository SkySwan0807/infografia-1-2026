# ejercicio 1: correr (sprint).
#
# objetivo: mantener Shift presionado para moverse mas rapido.
# concepto clave: Input.is_action_pressed() es verdadero MIENTRAS la tecla
#   este apretada (a diferencia de is_action_just_pressed(), que es verdadero
#   solo el frame en que se aprieta).
#
# lo que ya esta hecho: movimiento 8-direccional normalizado.
# lo que tienes que completar (1 TODO):
#   1. si la accion "correr" esta presionada, usar speed_corriendo en vez de speed.
#
# correr: F6 sobre exercises/ex1_correr.tscn
# solucion: exercises/soluciones/ex1_correr_solved.gd

extends CharacterBody2D

@export var speed: float = 200.0
@export var speed_corriendo: float = 400.0

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	var velocidad_actual := speed
	# TODO 1: si "correr" esta presionada, velocidad_actual = speed_corriendo
	#   pista: if Input.is_action_pressed("correr"):

	velocity = direccion * velocidad_actual
	move_and_slide()
