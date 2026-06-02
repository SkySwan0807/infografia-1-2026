extends CharacterBody2D

# === PET / COMPAÑERO (EJERCICIO 🎓) =======================================
# El conejo es un ALIADO AUTONOMO. Su dificultad esta en el DOBLE objetivo:
# tiene que decidir, en cada frame, entre quedarse cerca del jugador y salir
# a pelear contra un enemigo que detecte.
#
# Lo que YA esta hecho (no lo toques):
#   - FOLLOW: sigue al jugador.
#   - HURT: se aturde cuando lo golpean (via señal de Health).
#   - _update_animation(): anima el conejo por codigo (fila = direccion).
#   - DetectionArea: guarda en `target` el enemigo que ve (y lo limpia al salir).
#   - _set_state(): mecanica de ATTACK/HURT (timer + prender/apagar la HitBox).
#
# TU TAREA: darle vida al combate. Busca los  # TODO  mas abajo.
#   1) En _follow(): si hay un `target` valido Y estamos dentro del leash,
#      pasar a CHASE.
#   2) _chase(): acercarse al enemigo; si esta a tiro (ATTACK_RANGE) atacar;
#      si lo perdimos o nos alejamos del jugador (leash), volver a FOLLOW.
#   3) _attack(): quedarse quieto mientras corre el timer; al terminar,
#      apagar la HitBox y re-decidir (_back_to_default()).
#
# Solucion de referencia: _solutions/pet_solved.gd
# ==========================================================================

enum State { FOLLOW, CHASE, ATTACK, HURT }
var state := State.FOLLOW

@export var player_path: NodePath
@export var max_speed := 95.0

const ACCEL := 700.0
const FOLLOW_DISTANCE := 26.0    # mas cerca que esto del jugador => se queda quieto
const ATTACK_RANGE := 16.0       # mas cerca que esto del enemigo => ataca
const LEASH_RANGE := 110.0       # mas lejos que esto del jugador => abandona la pelea
const ATTACK_TIME := 0.35
const HURT_TIME := 0.25

var player: Node2D
var target: Node2D = null         # enemigo actual (o null) — lo llena el DetectionArea
var _timer := 0.0
var _row := 0                     # ultima fila/direccion usada para la animacion

@onready var sprite: Sprite2D = $Sprite2D
@onready var health: Health = $Health
@onready var hit_shape: CollisionShape2D = $HitBox/CollisionShape2D


func _ready() -> void:
	player = get_node_or_null(player_path)
	health.health_changed.connect(_on_health_changed)
	health.health_depleted.connect(_on_health_depleted)
	hit_shape.disabled = true


func _physics_process(delta: float) -> void:
	match state:
		State.FOLLOW:
			_follow(delta)
		State.CHASE:
			_chase(delta)
		State.ATTACK:
			_attack(delta)
		State.HURT:
			_hurt(delta)
	move_and_slide()
	_update_animation()


func _follow(delta: float) -> void:
	if is_instance_valid(target) and _within_leash():
		_set_state(State.CHASE)
		return

	if player and global_position.distance_to(player.global_position) > FOLLOW_DISTANCE:
		var dir := global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(dir * max_speed, ACCEL * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)


func _chase(_delta: float) -> void:
	if not is_instance_valid(target) or not _within_leash():
		_set_state(State.FOLLOW)
		return

	var distance := global_position.distance_to(target.global_position)

	if distance <= ATTACK_RANGE:
		_set_state(State.ATTACK)
		return

	var dir := global_position.direction_to(target.global_position)
	velocity = velocity.move_toward(dir * max_speed, ACCEL * _delta)


func _attack(_delta: float) -> void:
	velocity = Vector2.ZERO

	_timer -= _delta

	if _timer <= 0.0:
		hit_shape.disabled = true
		_back_to_default()


# --- YA HECHO de aca para abajo -------------------------------------------

func _hurt(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
	_timer -= delta
	if _timer <= 0.0:
		_back_to_default()


func _set_state(new_state: State) -> void:
	state = new_state
	match new_state:
		State.ATTACK:
			_timer = ATTACK_TIME
			hit_shape.disabled = false   # la HitBox vive SOLO durante el ataque
		State.HURT:
			_timer = HURT_TIME


func _back_to_default() -> void:
	_set_state(State.CHASE if (is_instance_valid(target) and _within_leash()) else State.FOLLOW)


func _within_leash() -> bool:
	return player != null and global_position.distance_to(player.global_position) <= LEASH_RANGE


# --- animacion por codigo: fila = direccion, columnas 1..3 = caminar ---
func _update_animation() -> void:
	if velocity.length() > 5.0:
		_row = _facing_row(velocity)
		var step := int(Time.get_ticks_msec() / 120.0) % 3 + 1
		sprite.frame = _row * 4 + step
	else:
		sprite.frame = _row * 4


func _facing_row(v: Vector2) -> int:
	# filas de CharacterSprites: 0=abajo, 1=arriba, 2=izquierda, 3=derecha
	if abs(v.x) > abs(v.y):
		return 3 if v.x > 0.0 else 2
	return 0 if v.y > 0.0 else 1


# --- señales ---
func _on_detection_area_area_entered(area: Area2D) -> void:
	target = area.owner


func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.owner == target:
		target = null


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBox and state != State.HURT:
		health.take_damage(area)


func _on_health_changed(_old_value: int, new_value: int) -> void:
	if new_value > 0:
		_set_state(State.HURT)


func _on_health_depleted() -> void:
	queue_free()
