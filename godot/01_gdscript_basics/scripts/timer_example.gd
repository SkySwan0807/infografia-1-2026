extends Node2D

func _ready() -> void:
	$Timer.timeout.connect(explode)
	$Timer.start()
	print("Bomb planted")

func explode():
	print("BOOM! 💥")
	queue_free()
