# SESIÓN B · escena 07 — NavigationAgent2D: el camino del motor.  ✅ demo (contraste)
#
# Misma tarea que el A* nuestro, pero usando el sistema de navegación de Godot:
#   - el NavigationAgent2D recibe un target_position y calcula el camino solo;
#   - cada frame le pedimos get_next_path_position() y vamos hacia ahí.
#
# Ventajas: el camino es suave (no pega a la grilla) y trae evasión entre agentes
# gratis. A cambio, el navmesh es más opaco que una grilla que ves celda a celda.
# Es el trade-off de la sesión: grilla transparente (A*) vs navmesh del motor.

extends CharacterBody2D

@export var player_path: NodePath
@export var max_speed: float = 65.0

@onready var agente: NavigationAgent2D = $NavigationAgent2D

var player: Node2D


func _ready() -> void:
	player = get_node_or_null(player_path)
	set_physics_process(false)
	call_deferred("_arrancar")


func _arrancar() -> void:
	# esperamos a que el navmesh esté horneado y sincronizado en el servidor
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)


func _physics_process(_delta: float) -> void:
	if player:
		agente.target_position = player.global_position
	if agente.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var siguiente := agente.get_next_path_position()
		velocity = global_position.direction_to(siguiente) * max_speed
	move_and_slide()
