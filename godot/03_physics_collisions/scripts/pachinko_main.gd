# Pachinko / Galton board.
#
# Las bolas (RigidBody2D) caen desde arriba, rebotan contra los clavos
# (StaticBody2D) en disposicion ofset, y terminan en alguna de las cajas
# (Area2D) de abajo. Aleatoriedad emergente desde fisica determinista.
#
# Es el opener de la sesion: los tres tipos de cuerpo trabajando juntos.
#
# Correr con F6 sobre scenes/01_pachinko.tscn.

extends Node2D

const PegScene := preload("res://scenes/peg.tscn")
const BallScene := preload("res://scenes/ball.tscn")

@export var filas: int = 7
@export var columnas: int = 11
@export var separacion: Vector2 = Vector2(80, 70)
@export var intervalo_spawn: float = 0.5

@onready var pegs_root: Node2D = $Pegs
@onready var balls_root: Node2D = $Balls
@onready var spawner: Marker2D = $Spawner
@onready var timer: Timer = $Spawner/Timer

func _ready() -> void:
	_colocar_clavos()
	timer.wait_time = intervalo_spawn
	timer.timeout.connect(_dropear_bola)
	timer.start()

func _colocar_clavos() -> void:
	var inicio_x: float = -float(columnas - 1) * separacion.x / 2.0
	for fila in range(filas):
		var offset_x: float = separacion.x / 2.0 if fila % 2 == 1 else 0.0
		var cols_en_fila := columnas if fila % 2 == 0 else columnas - 1
		for col in range(cols_en_fila):
			var clavo: Node2D = PegScene.instantiate()
			clavo.position = Vector2(inicio_x + col * separacion.x + offset_x, fila * separacion.y)
			pegs_root.add_child(clavo)

func _dropear_bola() -> void:
	var bola: RigidBody2D = BallScene.instantiate()
	bola.position = spawner.position + Vector2(randf_range(-20, 20), 0)
	balls_root.add_child(bola)
