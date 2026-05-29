extends Node2D

# === Sesión 4, parte 1 ================================
# Lo más básico: un AnimationPlayer reproduce una animación.
# Una animación es una lista de PROPIEDADES que cambian en el tiempo.
#   - "caminar" anima Sprite2D:frame  → el clásico flipbook.
#   - "rebote"  anima scale y modulate → la MISMA herramienta sirve para
#     cualquier propiedad, no solo el frame.
# Mensaje de la parte 1: "AnimationPlayer anima CUALQUIER propiedad".
# ==========================================================================

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("caminar")


func _unhandled_input(event: InputEvent) -> void:
	# ESPACIO → reproduce el "rebote" (squash & stretch + flash de color).
	if event.is_action_pressed("attack"):
		animation_player.play("rebote")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# Al terminar el rebote, volvemos a caminar.
	if anim_name == "rebote":
		animation_player.play("caminar")
