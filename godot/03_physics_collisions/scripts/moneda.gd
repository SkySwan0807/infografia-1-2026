# (PLACEHOLDER del docente) Moneda recolectable.
#
# La moneda es un Area2D: NO bloquea al jugador, solo lo DETECTA.
# Cuando el cuerpo del jugador entra al area, Godot emite la senal
# body_entered con el nodo que entro como parametro.
#
# TODO (en clase): completar el handler para que la moneda desaparezca
#   y le sume al jugador.
#
# Configuracion de capas (en el editor, ya hecha en la escena):
#   collision_layer = "recolectable" (que cosa SOY)
#   collision_mask  = "jugador"      (que cosas DETECTO)

extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# TODO: el body que entra es el jugador (CharacterBody2D).
	#   pista 1: el jugador tiene metodo body.sumar_moneda() para incrementar el contador
	#   pista 2: queue_free() elimina este nodo (la moneda)
	pass
