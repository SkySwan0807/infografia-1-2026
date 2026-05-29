# (PLACEHOLDER del docente) Pua / zona de dano.
#
# Misma estructura que la moneda (Area2D + body_entered) pero el efecto
# es opuesto: en vez de "ganar algo y desaparecer", la pua dana al jugador
# y se queda donde esta (puede pisarse muchas veces).
#
# TODO (en clase): completar el handler para danar al jugador.
#
# Configuracion de capas (ya hecha en la escena):
#   collision_layer = "hazard"   (que cosa SOY)
#   collision_mask  = "jugador"  (que cosas DETECTO)

extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# TODO: el body que entra es el jugador.
	#   pista: el jugador tiene metodo body.recibir_dano()
	#   (a diferencia de la moneda, la pua NO se elimina: queda como peligro permanente)
	body.recibir_dano()
