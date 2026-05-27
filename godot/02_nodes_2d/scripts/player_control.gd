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
class_name PlayerControl

signal se_movio(direccion: Vector2)

@export var body: CharacterBody2D
@export var speed: float = 200.0

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	# movemos el cuerpo EXTERNO (no a nosotros mismos)
	body.velocity = direccion * speed
	body.move_and_slide()

	# avisamos la direccion; quien quiera (ej. el sprite) reacciona
	if direccion != Vector2.ZERO:
		se_movio.emit(direccion)
