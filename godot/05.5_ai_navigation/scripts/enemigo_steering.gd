# SESIÓN A · escena 01 — STEERING básico (seek + arrive).  ✅ demo
#
# La forma más simple de "IA de movimiento": cada frame, mirá hacia dónde está el
# objetivo y andá hacia ahí. Dos ideas:
#
#   seek   : la velocidad DESEADA apunta al objetivo, a máxima rapidez.
#   arrive : cuando estás cerca (< arrive_radius), bajás la rapidez de a poco para
#            no pasarte de largo y frenar suave encima del objetivo.
#
# No hay mapa todavía: campo abierto. Esto anda perfecto SIN paredes. El problema
# (chocar contra los muros) aparece en la escena 02, y se resuelve en la sesión B.

extends CharacterBody2D

@export var player_path: NodePath
@export var max_speed: float = 70.0
@export var arrive_radius: float = 28.0   # adentro de este radio, empieza a frenar
@export var stop_radius: float = 5.0      # adentro de este radio, ya llegó

const ACCEL := 600.0

var player: Node2D


func _ready() -> void:
	player = get_node_or_null(player_path)


func _physics_process(delta: float) -> void:
	if player == null:
		return

	var hacia := player.global_position - global_position
	var dist := hacia.length()

	var deseada := Vector2.ZERO
	if dist > stop_radius:
		var rapidez := max_speed
		if dist < arrive_radius:
			rapidez = max_speed * (dist / arrive_radius)   # arrive: frena al acercarse
		deseada = hacia.normalized() * rapidez

	# move_toward = aceleración: no saltamos a la velocidad deseada, llegamos de a poco
	velocity = velocity.move_toward(deseada, ACCEL * delta)
	move_and_slide()
