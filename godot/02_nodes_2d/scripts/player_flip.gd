# (PLACEHOLDER del docente) Voltear el sprite segun la direccion.
#
# objetivo: que el sprite "mire" hacia donde se mueve el jugador.
# lo que ya esta hecho: movimiento 8-direccional normalizado + referencia al Sprite2D.
# lo que falta completar EN VIVO (1 TODO): voltear el sprite con flip_h.
#
# correr: F6 sobre scenes/02_flip.tscn

extends CharacterBody2D

@export var speed: float = 200.0
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	var direccion := Vector2.ZERO
	direccion.x = Input.get_axis("izquierda", "derecha")
	direccion.y = Input.get_axis("arriba", "abajo")
	direccion = direccion.normalized()

	velocity = direccion * speed
	move_and_slide()

	# TODO (en clase): voltear el sprite segun la direccion horizontal.
	#   - si direccion.x < 0  -> mirar a la izquierda  (sprite.flip_h = true)
	#   - si direccion.x > 0  -> mirar a la derecha     (sprite.flip_h = false)
	#   - si direccion.x == 0 -> dejar el sprite como esta (no hacer nada)
	#
	# pista: Sprite2D tiene la propiedad booleana flip_h
