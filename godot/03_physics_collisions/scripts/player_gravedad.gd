# (PLACEHOLDER del docente) Gravedad y salto en CharacterBody2D.
#
# Es la primera vez en el modulo que el mundo TIENE gravedad. La sesion 2
# fue top-down, sin gravedad: el jugador se quedaba quieto si no apretabas
# una tecla. Hoy NO: si no aplicas gravedad, el jugador se queda flotando
# (porque velocity arranca en cero). La gravedad la pone tu codigo.
#
# Lo que ya esta hecho: la escena tiene piso, paredes, plataformas y el
# sprite del jugador. Lo que falta completar EN VIVO (3 TODOs):
#   1. aplicar gravedad cada frame
#   2. leer input horizontal y setear velocity.x
#   3. saltar SI esta en el piso Y se aprieta saltar
#
# Correr: F6 sobre scenes/02_gravedad_y_salto.tscn

extends CharacterBody2D

const GRAVEDAD: float = 1200.0
const VELOCIDAD_HORIZONTAL: float = 280.0
const VELOCIDAD_SALTO: float = -720.0  # negativo: en Godot Y crece hacia abajo

func _physics_process(delta: float) -> void:
	# TODO 1: aplicar gravedad cada frame.
	#   pista: sumar GRAVEDAD * delta a velocity.y
	#   (move_and_slide() ya consume velocity, pero no agrega gravedad por si solo)
	velocity.y += GRAVEDAD * delta
	# TODO 2: leer input horizontal y setear velocity.x.
	#   pista: Input.get_axis("izquierda", "derecha") devuelve -1, 0 o 1
	#   multiplicalo por VELOCIDAD_HORIZONTAL y asignalo a velocity.x
	var dir_horizontal = Input.get_axis("izquierda", "derecha")
	velocity.x = dir_horizontal * VELOCIDAD_HORIZONTAL
	# TODO 3: saltar si esta en el piso Y se aprieta saltar.
	#   pista: is_on_floor() es metodo de CharacterBody2D
	#   usar is_action_just_pressed (no pressed) para que sea un toque
	#   asignar velocity.y = VELOCIDAD_SALTO (negativo = hacia arriba)
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = VELOCIDAD_SALTO
		
	move_and_slide()
