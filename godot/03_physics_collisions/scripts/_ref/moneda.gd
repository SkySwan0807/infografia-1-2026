# Referencia: solucion del placeholder scripts/moneda.gd.

extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	body.sumar_moneda()
	queue_free()
