extends CharacterBody2D

# === Sesión 4 ==========================================
# La idea de la clase: hay DOS máquinas de estado.
#   1) Esta, en código (enum MOVE/ATTACK) — decide la LÓGICA.
#   2) El AnimationTree del nodo — decide cómo se VE.
# El código nunca dice "mostrá el frame 14"; dice "estoy en Run hacia la
# derecha" y el AnimationTree elige la animación.
# ==========================================================================

const ACCELERATION := 600.0
const FRICTION := 600.0
const MAX_SPEED := 110.0

# --- máquina de estado en CÓDIGO ---
enum { MOVE, ATTACK }
var state := MOVE

@onready var animation_tree: AnimationTree = $AnimationTree
# El "playback" es el control de la máquina de estado del AnimationTree.
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var health: Health = $Health


func _ready() -> void:
	animation_tree.active = true
	# La vida no sabe de animaciones: solo avisa con señales y nosotros reaccionamos.
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
		# TODO: pasarle la dirección al BlendSpace2D de cada estado
		# para que el AnimationTree sepa hacia dónde mirar.
		#   animation_tree.set("parameters/Idle/blend_position", input_vector)
		#   animation_tree.set("parameters/Run/blend_position", input_vector)
		#   animation_tree.set("parameters/Attack/blend_position", input_vector)
		# TODO: transicion al estado visual "Run"
		#   state_machine.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# TODO: transicion al estado visual "Idle"
		#   state_machine.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		# TODO: cambiar la máquina de CÓDIGO a ATTACK
		#   state = ATTACK
		pass


func attack_state() -> void:
	# Durante el ataque el player se queda quieto y deja que la animación corra.
	velocity = Vector2.ZERO
	# TODO: transicion al estado visual "Attack"
	#   state_machine.travel("Attack")


# Lo llama una PISTA DE MÉTODO al final de la animación de ataque.
# Así la animación le devuelve el control a la lógica (vuelve a MOVE).
func attack_anim_finished() -> void:
	state = MOVE


# El HurtBox del player detecta un HitBox enemigo (capas de la sesión 3).
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBox:
		health.take_damage(area)


func _on_health_changed(_old_value: int, new_value: int) -> void:
	print("player hp: ", new_value)


func _on_health_depleted() -> void:
	print("player murió")
	set_physics_process(false)
