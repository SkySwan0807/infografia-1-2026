# El cuerpo controlado por PlayerControl (demo completo).
#
# No lee input. Solo reacciona a la señal se_movio (conectada en el editor)
# para voltear su sprite hacia donde va. Quien lo mueve es PlayerControl.

extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

func _on_se_movio(direccion: Vector2) -> void:
	if direccion.x < 0:
		sprite.flip_h = true
	elif direccion.x > 0:
		sprite.flip_h = false
