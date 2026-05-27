# ejercicio 3: ataque con cooldown — SOLUCION.

extends CharacterBody2D

@export var speed: float = 200.0

enum Estado { MOVER, ATACAR }
var estado: Estado = Estado.MOVER

@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	match estado:
		Estado.MOVER:
			_estado_mover(delta)
		Estado.ATACAR:
			_estado_atacar(delta)

func _estado_mover(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	velocity = direccion.normalized() * speed
	move_and_slide()

	if Input.is_action_just_pressed("atacar"):
		estado = Estado.ATACAR
		velocity = Vector2.ZERO
		timer.start()
		print("atacando!")

func _estado_atacar(_delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()

func _on_timer_timeout() -> void:
	estado = Estado.MOVER
