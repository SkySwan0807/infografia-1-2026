# MÓDULO 8 · Sesión 1 — el FLOCK (manager, demo completo).
#
# No tiene lógica de bandada: solo CREA los boids y les guarda los datos comunes
# (los pesos de cada regla, el tamaño del mundo, el objetivo del atractor). Cada
# boid lee de acá. Cambiar los pesos en el inspector cambia el comportamiento de
# todo el grupo — eso es lo que separa a las escenas 01..04.

extends Node2D

@export var boid_escena: PackedScene
@export var cantidad: int = 60

@export_group("Pesos de las reglas")
@export var peso_separacion: float = 1.5
@export var peso_alineacion: float = 1.0
@export var peso_cohesion: float = 1.0

@export_group("Atractor (perseguir el mouse)")
@export var atractor_activo: bool = false
@export var peso_atractor: float = 1.2

var boids: Array[Node2D] = []
var mundo := Vector2(640, 360)


func _ready() -> void:
	mundo = get_viewport_rect().size
	for i in cantidad:
		var b: Node2D = boid_escena.instantiate()
		b.position = Vector2(randf_range(0.0, mundo.x), randf_range(0.0, mundo.y))
		add_child(b)
		boids.append(b)


# a dónde tira el atractor: la posición del mouse
func objetivo() -> Vector2:
	return get_global_mouse_position()
