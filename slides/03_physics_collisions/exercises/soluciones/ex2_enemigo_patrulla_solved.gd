# solucion del ejercicio 2: enemigo que patrulla.

extends CharacterBody2D

const VELOCIDAD: float = 120.0
const GRAVEDAD: float = 1200.0

@export var x_min: float = 280.0
@export var x_max: float = 1080.0

var direccion_x: float = -1.0
@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta
	velocity.x = direccion_x * VELOCIDAD

	if position.x < x_min:
		direccion_x = 1.0
	elif position.x > x_max:
		direccion_x = -1.0

	move_and_slide()

func _on_hurtbox_body_entered(body: Node) -> void:
	if body.has_method("recibir_dano"):
		body.recibir_dano()
