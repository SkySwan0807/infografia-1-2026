extends CharacterBody2D

# === EJERCICIO (🎓) — Máquina de estado del enemigo =======================
# Objetivo: darle al murciélago su PROPIA máquina de estado, igual que el
# player de la demo, pero diseñada por ti. Cinco estados:
#
#   PATROL  → se pasea de un lado a otro
#   CHASE   → detectó al player y lo persigue
#   ATTACK  → está cerca: ataca (la animación activa el HitBox)
#   HURT    → lo golpearon: reacciona (interrumpe lo que hacía)
#   DIE     → se quedó sin vida: muere y se borra
#
# La escena ya trae armado el AnimationTree con los estados visuales
# (fly / attack / hurt / die) y el AnimationPlayer con sus animaciones.
# TU TRABAJO es la máquina de CÓDIGO que lo maneja con state_machine.travel().
#
# Pista clave: igual que el player, hay DOS máquinas. _set_state() debe ser
# el único lugar donde sincronizas la de código con la del AnimationTree.
#
# Cuando termines, pedile al docente la solución de referencia para comparar.
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


# TODO 1: este es el puente entre las dos máquinas.
# Cambiá `state` al nuevo estado y, según cuál sea, viajá al estado VISUAL
# correcto del AnimationTree con state_machine.travel("..."):
#   PATROL / CHASE -> "fly"   ·   ATTACK -> "attack"
#   HURT -> "hurt"            ·   DIE -> "die"
func _set_state(new_state: State) -> void:
	state = new_state
	pass # <-- reemplazá con el match que llama a state_machine.travel(...)


# TODO 2: moverse en la dirección de patrullaje (patrol_dir) a PATROL_SPEED.
# Acordate de voltear el sprite según hacia dónde va (sprite.flip_h).
func _patrol(_delta: float) -> void:
	pass


# TODO 3: perseguir al target.
#  - si el target ya no existe -> volver a PATROL
#  - calcular la dirección hacia el target y voltear el sprite
#  - si está más cerca que ATTACK_RANGE -> pasar a ATTACK
#  - si no, moverse hacia él a CHASE_SPEED
func _chase(_delta: float) -> void:
	pass


# TODO 4: el DetectionArea detectó algo (es el player).
# Guardá el target (area.owner) y, si estabas en PATROL, pasá a CHASE.
func _on_detection_area_area_entered(_area: Area2D) -> void:
	pass


# TODO 5: el player salió del rango de detección.
# Olvidá el target y, si estabas en CHASE, volvé a PATROL.
func _on_detection_area_area_exited(_area: Area2D) -> void:
	pass


# TODO 6: te golpeó el HitBox del player.
# Si es un HitBox y no estás muriendo, restá vida con health.take_damage(area).
func _on_hurt_box_area_entered(_area: Area2D) -> void:
	pass


# TODO 7: la vida cambió. Si todavía queda vida (>0) y no estás muriendo,
# reaccioná pasando al estado HURT.
func _on_health_changed(_old_value: int, _new_value: int) -> void:
	pass


# TODO 8: la vida llegó a 0. Pasá al estado DIE.
func _on_health_depleted() -> void:
	pass


# --- pistas de método: las llama la animación al terminar (ya cableadas) ---

# TODO 9: terminó la animación de ataque. Volvé a CHASE (si hay target) o PATROL.
func attack_anim_finished() -> void:
	pass


# TODO 10: terminó la animación de daño. Volvé a CHASE (si hay target) o PATROL.
func hurt_anim_finished() -> void:
	pass


# TODO 11: terminó la animación de muerte. Borrá el nodo con queue_free().
func die_anim_finished() -> void:
	pass
