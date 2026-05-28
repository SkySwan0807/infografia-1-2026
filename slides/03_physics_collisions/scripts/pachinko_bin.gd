# Caja que cuenta cuantas bolas cayeron en ella.
#
# Es un Area2D: detecta sin chocar. Cuando una bola (RigidBody2D)
# entra, body_entered se dispara, contamos +1 y eliminamos la bola.

extends Area2D

@export var etiqueta: String = "?"
var conteo: int = 0
@onready var label: Label = $Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_actualizar()

func _on_body_entered(body: Node) -> void:
	conteo += 1
	_actualizar()
	body.queue_free()

func _actualizar() -> void:
	label.text = "%s\n%d" % [etiqueta, conteo]
