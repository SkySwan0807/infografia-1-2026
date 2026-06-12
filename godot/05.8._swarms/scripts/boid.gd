# MÓDULO 8 · Sesión 1 — un BOID (demo completo).
#
# Un boid no tiene un cerebro ni un plan. Cada frame mira a sus VECINOS (los que
# están dentro de NEIGHBOR_RADIUS) y suma tres impulsos — las reglas de Reynolds:
#
#   separación : alejarse de los que están MUY cerca (no amontonarse).
#   alineación : apuntar hacia la dirección PROMEDIO de los vecinos.
#   cohesión   : ir hacia la posición PROMEDIO de los vecinos (el centro del grupo).
#
# Cada regla devuelve un "steering" = (velocidad_deseada - velocidad_actual), el
# mismo truco de la sesión 5.5. La bandada que ves NO está programada: EMERGE de
# que cada uno sigue estas tres reglas locales. Eso es comportamiento emergente.
#
# Los PESOS de cada regla los pone el Flock (el padre); cambiándolos se pasa de
# "se dispersan" a "se ordenan" a "se juntan". Cada escena 01..04 usa pesos distintos.

extends Node2D

const MAX_SPEED := 130.0
const MIN_SPEED := 50.0
const NEIGHBOR_RADIUS := 48.0   # a quién considero "vecino"
const SEP_RADIUS := 22.0        # a quién considero "demasiado cerca"

var velocity := Vector2.ZERO
var flock: Node                 # el manager (padre): trae pesos, lista y mundo


func _ready() -> void:
	flock = get_parent()
	velocity = Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * MAX_SPEED


func _physics_process(delta: float) -> void:
	var sep := Vector2.ZERO
	var ali := Vector2.ZERO
	var coh := Vector2.ZERO
	var vecinos := 0
	var cercanos := 0

	for otro in flock.boids:
		if otro == self:
			continue
		var d := position.distance_to(otro.position)
		if d < NEIGHBOR_RADIUS:
			ali += otro.velocity
			coh += otro.position
			vecinos += 1
			if d < SEP_RADIUS and d > 0.0:
				sep += (position - otro.position) / d   # más cerca => empuje más fuerte
				cercanos += 1

	var accel := Vector2.ZERO
	if cercanos > 0:
		sep /= cercanos
		accel += _steer(sep) * flock.peso_separacion
	if vecinos > 0:
		ali /= vecinos
		accel += _steer(ali) * flock.peso_alineacion
		var hacia_centro := (coh / vecinos) - position
		accel += _steer(hacia_centro) * flock.peso_cohesion

	if flock.atractor_activo:
		var hacia: Vector2 = flock.objetivo() - position
		accel += _steer(hacia) * flock.peso_atractor

	velocity = (velocity + accel * delta).limit_length(MAX_SPEED)
	if velocity.length() < MIN_SPEED:
		velocity = velocity.normalized() * MIN_SPEED
	position += velocity * delta
	_envolver()
	rotation = velocity.angle()   # el triángulo apunta hacia donde va


# steering = la velocidad que QUIERO menos la que TENGO (girar hacia el deseo)
func _steer(deseo: Vector2) -> Vector2:
	if deseo.length() < 0.001:
		return Vector2.ZERO
	return deseo.normalized() * MAX_SPEED - velocity


# mundo toroidal: el que sale por un borde aparece por el opuesto
func _envolver() -> void:
	var m: Vector2 = flock.mundo
	if position.x < 0.0: position.x += m.x
	elif position.x > m.x: position.x -= m.x
	if position.y < 0.0: position.y += m.y
	elif position.y > m.y: position.y -= m.y
