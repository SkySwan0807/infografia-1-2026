# MÓDULO 8 · Sesión 2 — AGENTE de flujo (demo completo).
#
# Lo más simple que puede hacer un agente con un flow field: leer el vector de su
# celda y caminar hacia ahí. No piensa, no busca: el campo ya tiene la respuesta.
# Cientos de estos corren baratísimo porque el A* se hizo UNA vez al armar el campo.

extends Node2D

const MAX_SPEED := 80.0
const ACCEL := 400.0

var velocity := Vector2.ZERO
var campo: Node    # el flow field (lo setea quien lo crea)


func _physics_process(delta: float) -> void:
	if campo == null:
		return
	var deseada: Vector2 = campo.flujo_en(position) * MAX_SPEED
	velocity = velocity.move_toward(deseada, ACCEL * delta)
	position += velocity * delta
	if velocity.length() > 1.0:
		rotation = velocity.angle()
