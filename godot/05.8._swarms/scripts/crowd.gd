# MÓDULO 8 · Sesión 2 — la MULTITUD (manager, demo completo).
#
# Crea N agentes en una zona libre y les pasa el flow field que tienen que seguir
# (y, para la separación, una referencia a la lista de agentes). El campo hace
# el trabajo difícil una vez; sumar agentes es casi gratis.

extends Node2D

@export var agente_escena: PackedScene
@export var cantidad: int = 200
@export var campo_path: NodePath
@export var zona_x: float = 0.4   # los agentes nacen en el 40% izquierdo

var agentes: Array[Node2D] = []
var campo: Node


func _ready() -> void:
	campo = get_node(campo_path)
	var mundo := get_viewport_rect().size
	for i in cantidad:
		var a: Node2D = agente_escena.instantiate()
		a.position = _pos_libre(mundo)
		a.campo = campo
		if "crowd" in a:
			a.crowd = self
		add_child(a)
		agentes.append(a)


func _pos_libre(mundo: Vector2) -> Vector2:
	for _intento in 30:
		var p := Vector2(randf_range(10.0, mundo.x * zona_x), randf_range(10.0, mundo.y - 10.0))
		if not campo.es_pared(p):
			return p
	return Vector2(20.0, 20.0)
