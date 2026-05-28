# Referencia del docente: solucion del placeholder scripts/player_gravedad.gd.
# Este archivo NO se usa por ninguna escena. Es solo para mirar la respuesta
# antes de la clase si necesitas refrescar.

extends CharacterBody2D

const GRAVEDAD: float = 1200.0
const VELOCIDAD_HORIZONTAL: float = 280.0
const VELOCIDAD_SALTO: float = -520.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta

	var dir := Input.get_axis("izquierda", "derecha")
	velocity.x = dir * VELOCIDAD_HORIZONTAL

	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = VELOCIDAD_SALTO

	move_and_slide()
