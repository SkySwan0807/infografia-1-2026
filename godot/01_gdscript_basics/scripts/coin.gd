class_name Coin
extends Area2D

# SIGNAL DEFINITION
signal coin_collected(value: int)

@export var coin_value: int = 10

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("coin touched by player")
		coin_collected.emit(coin_value)
		queue_free()
