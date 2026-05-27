# ejercicio 3: ataque con cooldown.
#
# objetivo: apretar J para atacar. Durante el ataque el jugador NO se mueve.
#   El ataque dura lo que dure el Timer; cuando termina, se puede volver a mover.
# concepto clave: una maquina de estados simple (MOVER / ATACAR) controla que
#   hace el jugador en cada momento. El Timer marca cuanto dura el ataque.
#
# lo que ya esta hecho: el enum de estados, la referencia al Timer, y el
#   match que despacha al estado actual.
# lo que tienes que completar (3 TODOs):
#   1. en MOVER, detectar "atacar" y pasar al estado ATACAR.
#   2. en ATACAR, quedarse quieto.
#   3. cuando el Timer termina, volver a MOVER.
#
# nota: la señal timeout del Timer ya esta conectada a _on_timer_timeout
#   (conexion hecha en el editor, ver el .tscn).
#
# correr: F6 sobre exercises/ex3_ataque.tscn
# solucion: exercises/soluciones/ex3_ataque_solved.gd

extends CharacterBody2D

@export var speed: float = 200.0

enum Estado { MOVER, ATACAR }
var estado: Estado = Estado.MOVER

@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	match estado:
		Estado.MOVER:
			_estado_mover(delta)
		Estado.ATACAR:
			_estado_atacar(delta)

func _estado_mover(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	velocity = direccion.normalized() * speed
	move_and_slide()

	# TODO 1: si se aprieta "atacar", pasar al estado ATACAR:
	#   estado = Estado.ATACAR
	#   velocity = Vector2.ZERO
	#   timer.start()        # el Timer define cuanto dura el ataque
	#   print("atacando!")

func _estado_atacar(_delta: float) -> void:
	# TODO 2: durante el ataque el jugador esta quieto.
	#   velocity = Vector2.ZERO
	#   move_and_slide()
	pass

func _on_timer_timeout() -> void:
	# TODO 3: el ataque termino -> volver a MOVER
	#   estado = Estado.MOVER
	pass
