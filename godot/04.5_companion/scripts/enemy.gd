extends CharacterBody2D

# === ENEMIGO (reutilizado, COMPLETO) ======================================
# Maquina de estado del murcielago, tal cual la sesion 4:
#   PATROL -> CHASE -> ATTACK -> HURT -> DIE
# Igual que el player hay DOS maquinas:
#   1) esta (enum State) decide la LOGICA / comportamiento.
#   2) el AnimationTree decide como se VE (fly / attack / hurt / die).
# _set_state() es el unico lugar donde las dos maquinas se sincronizan.
#
# OJO (novedad de 4.5): persigue a CUALQUIER aliado que entre en su
# DetectionArea -> tanto el player como el compañero (pet). Ambos tienen su
# HurtBox en la capa "player", asi que el enemigo no distingue: ataca al que
# detecte. Eso es lo que vuelve la pelea mas interesante.
# ==========================================================================

enum State { PATROL, CHASE, ATTACK, HURT, DIE }
var state: State = State.PATROL

const PATROL_SPEED := 25.0
const CHASE_SPEED := 70.0
const ACCEL := 300.0
const ATTACK_RANGE := 22.0

var target: Node2D = null
var patrol_dir := Vector2.RIGHT

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var health: Health = $Health


func _ready() -> void:
	animation_tree.active = true
	health.health_changed.connect(_on_health_changed)
	health.health_depleted.connect(_on_health_depleted)
	_set_state(State.PATROL)


func _physics_process(delta: float) -> void:
	match state:
		State.PATROL:
			_patrol(delta)
		State.CHASE:
			_chase(delta)
		State.ATTACK, State.DIE:
			velocity = Vector2.ZERO
		State.HURT:
			velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
	move_and_slide()


# Unico punto de sincronizacion entre las dos maquinas.
func _set_state(new_state: State) -> void:
	state = new_state
	match new_state:
		State.PATROL, State.CHASE:
			state_machine.travel("fly")
		State.ATTACK:
			state_machine.travel("attack")
		State.HURT:
			state_machine.travel("hurt")
		State.DIE:
			state_machine.travel("die")


func _patrol(delta: float) -> void:
	velocity = velocity.move_toward(patrol_dir * PATROL_SPEED, ACCEL * delta)
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0


func _chase(delta: float) -> void:
	if not is_instance_valid(target):
		_set_state(State.PATROL)
		return
	var dir := global_position.direction_to(target.global_position)
	sprite.flip_h = dir.x < 0.0
	if global_position.distance_to(target.global_position) <= ATTACK_RANGE:
		_set_state(State.ATTACK)
	else:
		velocity = velocity.move_toward(dir * CHASE_SPEED, ACCEL * delta)


# --- señales del DetectionArea (capa "enemy" detecta "player"/"pet") ---
func _on_detection_area_area_entered(area: Area2D) -> void:
	target = area.owner
	if state == State.PATROL:
		_set_state(State.CHASE)


func _on_detection_area_area_exited(_area: Area2D) -> void:
	target = null
	if state == State.CHASE:
		_set_state(State.PATROL)


# --- golpe recibido (HurtBox detecta un HitBox aliado) ---
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBox and state != State.DIE:
		health.take_damage(area)


func _on_health_changed(_old_value: int, new_value: int) -> void:
	if new_value > 0 and state != State.DIE:
		_set_state(State.HURT)


func _on_health_depleted() -> void:
	_set_state(State.DIE)


# --- pistas de metodo llamadas al final de cada animacion ---
func attack_anim_finished() -> void:
	if state == State.ATTACK:
		_set_state(State.CHASE if is_instance_valid(target) else State.PATROL)


func hurt_anim_finished() -> void:
	if state == State.HURT:
		_set_state(State.CHASE if is_instance_valid(target) else State.PATROL)


func die_anim_finished() -> void:
	queue_free()
