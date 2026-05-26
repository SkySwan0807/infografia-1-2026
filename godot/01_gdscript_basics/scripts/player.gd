class_name Player
extends CharacterBody2D

# propiedades
@export var speed: int = 300
@export var health: int = 100

func _ready() -> void:
	add_to_group("player")
	print("speed: ", speed)
	print("health: ", health)

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func take_damage(amount: int):
	health -= amount
	print("Player took damage! current health: ", health)

	if health <= 0:
		print("Player defeated")
		hide()
