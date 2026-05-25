extends Area2D

const SPEED = 600.0

func _process(delta: float) -> void:
	position.x += SPEED * delta
	
	
