extends CharacterBody2D

# === PLAYER (reutilizado, COMPLETO) =======================================
# Viene tal cual de la sesion 4 (animaciones). Aca ya es una pieza terminada:
# el combate fue la leccion de esa sesion, asi que en 4.5 lo usamos como
# bloque de construccion y no lo tocamos.
#
# Dos maquinas de estado:
#   1) enum MOVE/ATTACK en codigo  -> decide la LOGICA.
#   2) el AnimationTree            -> decide como se VE.
# state_machine.travel(...) es el unico puente entre las dos.
# ==========================================================================

const ACCELERATION := 600.0
const FRICTION := 600.0
const MAX_SPEED := 110.0

enum { MOVE, ATTACK }
var state := MOVE

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var health: Health = $Health


func _ready() -> void:
	animation_tree.active = true
	health.health_changed.connect(_on_health_changed)
	health.health_depleted.connect(_on_health_depleted)


func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()


func move_state(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		state_machine.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		state_machine.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state() -> void:
	velocity = Vector2.ZERO
	state_machine.travel("Attack")


# La llama una PISTA DE METODO al final de la animacion de ataque.
func attack_anim_finished() -> void:
	state = MOVE


# El HurtBox del player detecta un HitBox enemigo (capas de la sesion 3).
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBox:
		health.take_damage(area)


func _on_health_changed(_old_value: int, new_value: int) -> void:
	print("player hp: ", new_value)


func _on_health_depleted() -> void:
	print("player murio")
	set_physics_process(false)
