extends CharacterBody2D

# === DEMO COMPLETO (✅) — Sesión 4, parte 2 ================================
# El paso intermedio entre "una animación que se reproduce" (01) y el árbol
# con BlendSpace de la arena (03).
#
# Acá la máquina de estado es lo MÍNIMO: tres estados, una animación cada uno.
#   IDLE  -> animación "idle"
#   RUN   -> animación "run"
#   ATTACK-> animación "attack" (se reproduce una vez y vuelve)
#
# Igual que en la arena, hay DOS máquinas:
#   1) este enum (código) decide la lógica,
#   2) el AnimationTree (StateMachine) decide qué animación se ve.
# state_machine.travel("...") es el puente. Lo NUEVO de la arena después será
# que cada estado, en vez de una sola animación, sea un BlendSpace2D con las
# 4 direcciones. Acá NO hay direcciones todavía: el personaje siempre mira
# "hacia abajo". Una cosa a la vez.
# ==========================================================================

const SPEED := 90.0

enum { IDLE, RUN, ATTACK }
var state := IDLE

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _ready() -> void:
	animation_tree.active = true


func _physics_process(_delta: float) -> void:
	match state:
		IDLE, RUN:
			move_state()
		ATTACK:
			attack_state()
	move_and_slide()


func move_state() -> void:
	var input_vector := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if input_vector != Vector2.ZERO:
		state = RUN
		state_machine.travel("run")
		velocity = input_vector * SPEED
	else:
		state = IDLE
		state_machine.travel("idle")
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state() -> void:
	# Mientras ataca no se mueve; deja correr la animación.
	velocity = Vector2.ZERO
	state_machine.travel("attack")


# La llama una PISTA DE MÉTODO al final de la animación de ataque:
# así el estado vuelve solo a IDLE cuando el golpe termina.
func attack_anim_finished() -> void:
	state = IDLE
