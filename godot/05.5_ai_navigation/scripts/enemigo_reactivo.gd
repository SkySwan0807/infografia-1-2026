# SESIÓN A · escena 02 — IA REACTIVA: detección + máquina de estados.  ✅ demo
# (Esta es la escena principal de la sesión A: el escenario completo.)
#
# El enemigo decide qué hacer según un ESTADO, igual que la máquina de estados de
# la sesión 4, pero acá decide COMPORTAMIENTO, no animación:
#
#   PATRULLA : va y viene entre dos puntos. Si VE al jugador -> PERSIGUE.
#   PERSIGUE : va derecho hacia el jugador (steering). Si lo pierde de vista -> REGRESA.
#   REGRESA  : vuelve a su punto de inicio. Al llegar -> PATRULLA. Si lo ve -> PERSIGUE.
#
# "Ver" = el jugador está dentro del rango de visión Y no hay una pared en el medio.
# Eso último lo resuelve un RayCast2D (línea de vista) contra la capa "mundo".
#
# OJO con el final feliz: PERSIGUE es steering en LÍNEA RECTA. Funciona en campo
# abierto, pero el enemigo se TRABA contra el muro divisor: conoce la dirección al
# jugador, no el camino. Ese fracaso es el gancho de la sesión B (pathfinding).

extends CharacterBody2D

enum Estado { PATRULLA, PERSIGUE, REGRESA }

@export var player_path: NodePath
@export var max_speed: float = 60.0
@export var vision: float = 130.0
@export var patrol_offset: Vector2 = Vector2(0, 56)   # segundo punto de patrulla

const ACCEL := 700.0
const LLEGADA := 6.0

var player: Node2D
var estado: Estado = Estado.PATRULLA
var inicio: Vector2
var _punto_a: Vector2
var _punto_b: Vector2
var _destino_patrulla: Vector2

@onready var vista: RayCast2D = $LineaDeVista


func _ready() -> void:
	player = get_node_or_null(player_path)
	inicio = global_position
	_punto_a = inicio
	_punto_b = inicio + patrol_offset
	_destino_patrulla = _punto_b
	


func _physics_process(delta: float) -> void:
	match estado:
		Estado.PATRULLA:
			_patrulla(delta)
		Estado.PERSIGUE:
			_persigue(delta)
		Estado.REGRESA:
			_regresa(delta)
	move_and_slide()


func _patrulla(delta: float) -> void:
	if _ve_al_jugador():
		estado = Estado.PERSIGUE
		return
	# va y viene entre A y B
	if global_position.distance_to(_destino_patrulla) < LLEGADA:
		_destino_patrulla = _punto_a if _destino_patrulla == _punto_b else _punto_b
	_ir_hacia(_destino_patrulla, max_speed * 0.4, delta)


func _persigue(delta: float) -> void:
	if not _ve_al_jugador():
		estado = Estado.REGRESA
		return
	# steering en línea recta: SOLO conoce la dirección, no el camino (se traba)
	_ir_hacia(player.global_position, max_speed, delta)


func _regresa(delta: float) -> void:
	if _ve_al_jugador():
		estado = Estado.PERSIGUE
		return
	if global_position.distance_to(inicio) < LLEGADA:
		estado = Estado.PATRULLA
		return
	_ir_hacia(inicio, max_speed * 0.6, delta)


func _ir_hacia(objetivo: Vector2, rapidez: float, delta: float) -> void:
	var deseada := global_position.direction_to(objetivo) * rapidez
	velocity = velocity.move_toward(deseada, ACCEL * delta)


# ¿Ve al jugador? Dentro del rango y sin pared en el medio (línea de vista).
func _ve_al_jugador() -> bool:
	if player == null:
		return false
	if global_position.distance_to(player.global_position) > vision:
		return false
	vista.target_position = vista.to_local(player.global_position)
	vista.force_raycast_update()
	# si el rayo choca algo (una pared) antes de llegar al jugador, no lo ve
	return true#not vista.is_colliding()
