extends CharacterBody2D

# === ENEMIGO SIMPLE (✅) — usado en la DEMO de combate (arena) ============
# Este murciélago NO tiene máquina de estado de animación: solo persigue y
# muere. Es el "saco de boxeo" para mostrar el combate del PLAYER.
# El murciélago con máquina de estado completa es el EJERCICIO (03).
# ==========================================================================

const MAX_SPEED := 60.0
const ACCEL := 200.0

var target: Node2D = null
var player_detected := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: Health = $Health


func _ready() -> void:
	health.health_depleted.connect(_on_health_depleted)


func _physics_process(delta: float) -> void:
	if player_detected and is_instance_valid(target):
		var dir := global_position.direction_to(target.global_position)
		velocity = velocity.move_toward(dir * MAX_SPEED, ACCEL * delta)
		sprite.flip_h = dir.x < 0.0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCEL * delta)
	move_and_slide()


# Lo golpea el HitBox del player.
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBox:
		health.take_damage(area)
		_flash()


func _flash() -> void:
	modulate = Color(1, 0.4, 0.4)
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color.WHITE, 0.2)


func _on_detection_area_area_entered(area: Area2D) -> void:
	player_detected = true
	target = area.owner


func _on_detection_area_area_exited(_area: Area2D) -> void:
	player_detected = false
	target = null


func _on_health_depleted() -> void:
	queue_free()
