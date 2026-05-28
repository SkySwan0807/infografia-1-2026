# ejercicio 1: doble salto.
#
# objetivo: que el jugador pueda saltar HASTA 2 veces antes de tocar piso.
#   - primer salto: como siempre (estando en piso).
#   - segundo salto: en el aire, todavia sin haber tocado piso.
#   - al tocar piso, el contador se resetea.
#
# concepto clave: estado en una variable (saltos_usados) que el script
#   actualiza segun lo que pasa. Es el mismo patron que veras en sesion 4
#   con la maquina de estados de animaciones.
#
# lo que ya esta hecho: gravedad, movimiento horizontal, y el reset
#   del contador cuando is_on_floor() es true.
# lo que tienes que completar (1 TODO): cambiar la condicion del salto.
#
# correr: F6 sobre exercises/ex1_doble_salto.tscn
# solucion: exercises/soluciones/ex1_doble_salto_solved.gd

extends CharacterBody2D

const GRAVEDAD: float = 1200.0
const VELOCIDAD_HORIZONTAL: float = 280.0
const VELOCIDAD_SALTO: float = -700.0
const MAX_SALTOS: int = 2

var saltos_usados: int = 0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta

	var dir := Input.get_axis("izquierda", "derecha")
	velocity.x = dir * VELOCIDAD_HORIZONTAL

	if is_on_floor():
		saltos_usados = 0

	# TODO: doble salto.
	#   La condicion actual solo permite saltar si is_on_floor().
	#   Cambiar para que se pueda saltar si saltos_usados < MAX_SALTOS.
	#   Y acordate de incrementar saltos_usados cada vez que saltas.
	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = VELOCIDAD_SALTO

	move_and_slide()
