extends Area2D

@export var damage_amount: int = 10

func _ready() -> void:
	print("enemy spawned!")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		print("enemy collided with player")
		body.take_damage(damage_amount)
		queue_free()
