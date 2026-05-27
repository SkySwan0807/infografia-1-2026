# ejercicio 2: dash.
#
# objetivo: tocar Espacio para un impulso corto y rapido en la direccion
#   en la que te estas moviendo, con un cooldown para no spamearlo.
# concepto clave: un estado temporal (dura unos frames) + un cooldown,
#   ambos manejados con contadores que bajan con delta.
#
# lo que ya esta hecho: movimiento normal + las variables del dash + el
#   contador de cooldown que ya baja solo.
# lo que tienes que completar (3 TODOs):
#   1. detectar el inicio del dash y arrancarlo.
#   2. mientras el dash esta activo, moverse a dash_speed en _dash_dir.
#   3. si no hay dash, moverse normal.
#
# correr: F6 sobre exercises/ex2_dash.tscn
# solucion: exercises/soluciones/ex2_dash_solved.gd

extends CharacterBody2D

@export var speed: float = 200.0
@export var dash_speed: float = 700.0
@export var dash_tiempo: float = 0.15
@export var dash_cooldown: float = 0.6

var _dash_restante: float = 0.0
var _cooldown_restante: float = 0.0
var _dash_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_cooldown_restante = max(0.0, _cooldown_restante - delta)

	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	# TODO 1: arrancar el dash si:
	#   - se aprieta "dash"            -> Input.is_action_just_pressed("dash")
	#   - no hay dash activo           -> _dash_restante <= 0.0
	#   - el cooldown ya termino       -> _cooldown_restante <= 0.0
	#   - nos estamos moviendo         -> direccion != Vector2.ZERO
	#   entonces: _dash_restante = dash_tiempo
	#             _dash_dir = direccion
	#             _cooldown_restante = dash_cooldown

	if _dash_restante > 0.0:
		# TODO 2: estamos en dash
		#   velocity = _dash_dir * dash_speed
		#   _dash_restante -= delta
		pass
	else:
		# TODO 3: movimiento normal
		#   velocity = direccion * speed
		pass

	move_and_slide()
