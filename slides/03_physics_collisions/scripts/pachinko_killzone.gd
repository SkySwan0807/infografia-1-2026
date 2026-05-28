# Limpia bolas que pasan por debajo de las cajas sin caer en ninguna.
# Sin esto, las bolas se acumularian off-screen para siempre.

extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	body.queue_free()
