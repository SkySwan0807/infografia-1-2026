# EJERCICIO 🎓 — leer el mapa desde el código.
#
# Hasta ahora ESCRIBIMOS el mapa (set_cell). Ahora hay que LEERLO: averiguar
# qué tile está debajo del jugador y reaccionar. El mundo (mapa_con_agua.gd)
# tiene pasto y un estanque; cada tile trae un dato custom "tipo" = "suelo" o
# "agua" (configurado en datos.tres). La meta: que el jugador se FRENE en el agua.
#
# El puente entre el mundo en píxeles y la grilla de celdas es:
#   var celda := mapa.local_to_map(mapa.to_local(global_position))
# y para leer el dato del tile en esa celda:
#   var datos := mapa.get_cell_tile_data(celda)   # puede ser null si no hay tile
#   var tipo := datos.get_custom_data("tipo")      # el String que pusimos
#
# Mové con WASD / flechas. Cuando funcione, al entrar al agua deberías ir lento.

extends CharacterBody2D

@export var velocidad: float = 60.0
@export var mapa: TileMapLayer  # se asigna en el editor (la capa del mundo)

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")

	var factor := 1.0

	# TODO 🎓 1: averiguá qué celda pisa el jugador.
	#   pista: mapa.local_to_map(mapa.to_local(global_position))

	# TODO 🎓 2: leé los datos del tile en esa celda con get_cell_tile_data(celda).
	#   ojo: puede ser null (celda vacía). Si es null, no leas nada.

	# TODO 🎓 3: si el tile existe y su custom data "tipo" es "agua",
	#   poné factor = 0.4 (el jugador se mueve al 40% en el agua).
	#   pista: datos.get_custom_data("tipo") == "agua"

	velocity = direccion.normalized() * velocidad * factor
	move_and_slide()
