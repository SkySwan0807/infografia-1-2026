# Patron de separacion de responsabilidades (demo completo).
#
# Idea: separar QUIEN lee el input de QUIEN es el cuerpo fisico.
#   - PlayerControl (este nodo): lee teclado, decide la direccion, mueve el body.
#   - Body (CharacterBody2D externo): solo es el cuerpo; no sabe nada del input.
# Se comunican por una señal (se_movio) — igual que las señales de la sesion 1.
#
# Por que separar: permite reusar el mismo cuerpo con distintos controles
# (teclado, IA, control remoto) sin tocar el cuerpo. Es el patron de
# bunny/player_control.tscn, simplificado.

extends Node2D
class_name AIControl

signal se_movio_ai(direccion: Vector2)

@export var body: CharacterBody2D
@export var speed: float = 200.0

var dir: Vector2 = Vector2(0, 0)

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	

func _physics_process(_delta: float) -> void:

	body.velocity = dir * speed
	body.move_and_slide()

	# avisamos la direccion; quien quiera (ej. el sprite) reacciona
	if dir != Vector2.ZERO:
		se_movio_ai.emit(dir)


func on_timer_timeout():
	print("direccion aleatoria! ")
	dir.x = (randf() * 2) - 1
	dir.y = (randf() * 2) - 1
	
	dir = dir.normalized()
	
	
