# solucion del ejercicio 1: doble salto.

extends CharacterBody2D

const GRAVEDAD: float = 1200.0
const VELOCIDAD_HORIZONTAL: float = 280.0
const VELOCIDAD_SALTO: float = -700.0
const MAX_SALTOS: int = 2

var saltos_usados: int = 0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta

	var dir := Input.get_axis("izquierda", "derecha")
	velocity.x = dir * VELOCIDAD_HORIZONTAL

	if is_on_floor():
		saltos_usados = 0

	if saltos_usados < MAX_SALTOS and Input.is_action_just_pressed("saltar"):
		velocity.y = VELOCIDAD_SALTO
		saltos_usados += 1

	move_and_slide()
