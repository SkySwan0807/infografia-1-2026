# ejercicio 2: dash — SOLUCION.

extends CharacterBody2D

@export var speed: float = 200.0
@export var dash_speed: float = 700.0
@export var dash_tiempo: float = 0.15
@export var dash_cooldown: float = 0.6

var _dash_restante: float = 0.0
var _cooldown_restante: float = 0.0
var _dash_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_cooldown_restante = max(0.0, _cooldown_restante - delta)

	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	if Input.is_action_just_pressed("dash") and _dash_restante <= 0.0 \
			and _cooldown_restante <= 0.0 and direccion != Vector2.ZERO:
		_dash_restante = dash_tiempo
		_dash_dir = direccion
		_cooldown_restante = dash_cooldown

	if _dash_restante > 0.0:
		velocity = _dash_dir * dash_speed
		_dash_restante -= delta
	else:
		velocity = direccion * speed

	move_and_slide()
