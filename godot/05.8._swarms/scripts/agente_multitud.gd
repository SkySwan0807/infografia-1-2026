# MÓDULO 8 · Sesión 2 — AGENTE de MULTITUD.  🔨 placeholder del docente
#
# Igual que el agente de flujo, pero en una multitud densa los agentes se
# ENCIMAN: todos leen el mismo vector y se apelmazan. La solución es la regla de
# SEPARACIÓN de los boids (sesión 1): además del flujo, empujar lejos de los
# vecinos muy cercanos. Flow field (a dónde ir) + separación (no encimarse) =
# navegación de multitudes.
#
# >>> EN CLASE: completar el bloque TODO con la separación. Sin completar, los
#     agentes siguen el flujo pero se amontonan.

extends Node2D

const MAX_SPEED := 50.0
const ACCEL := 200.0
const SEP_RADIUS := 14.0

@export var peso_flujo: float = 1.0
@export var peso_separacion: float = 1.3

var velocity := Vector2.ZERO
var campo: Node
var crowd: Node    # para mirar a los vecinos


func _physics_process(delta: float) -> void:
	if campo == null:
		return
	var deseada: Vector2 = campo.flujo_en(position) * MAX_SPEED * peso_flujo

	var sep = Vector2.ZERO
	for a in crowd.agentes:
		if a == self:
			continue
		# encontrar a la vecindad cercana (separacion)
		var d = position.distance_to(a.position)
		if d < SEP_RADIUS and d > 0.0:
			sep += (position - a.position) / d
	
	if sep != Vector2.ZERO:
		deseada += sep.normalized() * MAX_SPEED * peso_separacion
		
	velocity = velocity.move_toward(deseada, ACCEL * delta)
	position += velocity * delta
	if velocity.length() > 1.0:
		rotation = velocity.angle()
