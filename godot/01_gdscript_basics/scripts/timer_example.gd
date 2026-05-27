extends Node2D

const TEX_INACTIVA = preload("res://assets/textures/bomb.png")
const TEX_ACTIVA = preload("res://assets/textures/bomb_active.png")

func _ready() -> void:
	$Sprite2D.texture = TEX_INACTIVA
	$Timer.timeout.connect(explode)
	print("Timer iniciado, emite en 5 segundos...")
	$Timer.start()
	
	$Timer2.timeout.connect(finish)

	print("Bomb planted")

func explode():
	print("Timer timeout")
	# cambiar sprite a textura activa
	$Sprite2D.texture = TEX_ACTIVA
	print("Timer iniciado, emite en 0.5 segundos...")
	$Timer2.start()
	
func finish():
	print("Timer2 timeout")
	print("BOOM! 💥")
	queue_free()
