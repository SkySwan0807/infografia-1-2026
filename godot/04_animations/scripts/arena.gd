extends Node2D

# === ARENA DE COMBATE (DEMO B) ============================================
# Junta todo: player con ataque (dos máquinas de estado) + un murciélago
# "saco de boxeo" + el componente Health con señales.
# La arena solo escucha la señal health_changed del player y actualiza el HUD.
# ==========================================================================

@onready var hud: Label = $CanvasLayer/HUD
@onready var player: Node = $Player


func _ready() -> void:
	var health: Health = player.get_node("Health")
	health.health_changed.connect(_on_player_health_changed)
	_update_hud(health.health)


func _on_player_health_changed(_old_value: int, new_value: int) -> void:
	_update_hud(new_value)


func _update_hud(hp: int) -> void:
	hud.text = "HP: %d" % hp
