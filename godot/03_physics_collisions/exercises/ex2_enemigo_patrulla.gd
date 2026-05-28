# ejercicio 2: enemigo que patrulla.
#
# objetivo: un enemigo que camina de izquierda a derecha en un rango
#   fijo (x_min..x_max), dando vuelta al llegar a los limites. Al tocar
#   al jugador, le hace dano (el jugador respawnea).
#
# concepto clave: dos cuerpos en el mismo nodo:
#   - el CharacterBody2D del enemigo, con su CollisionShape2D, MUEVE al enemigo.
#   - el Hurtbox (Area2D hijo) DETECTA al jugador y lo dana, sin afectar el movimiento.
#   Separar movimiento de deteccion es un patron muy comun en juegos 2D.
#
# lo que ya esta hecho: la escena con jugador, enemigo, su Hurtbox configurado
#   con la mascara correcta (scan = jugador), gravedad y la variable direccion_x.
# lo que tienes que completar (3 TODOs):
#   1. mover horizontalmente segun direccion_x.
#   2. dar vuelta cuando te saliste del rango x_min..x_max.
#   3. conectar la senal body_entered del Hurtbox.
#
# correr: F6 sobre exercises/ex2_enemigo_patrulla.tscn
# solucion: exercises/soluciones/ex2_enemigo_patrulla_solved.gd

extends CharacterBody2D

const VELOCIDAD: float = 120.0
const GRAVEDAD: float = 1200.0

@export var x_min: float = 280.0
@export var x_max: float = 1080.0

var direccion_x: float = -1.0
@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
	# TODO 3: conectar la senal body_entered del Hurtbox a _on_hurtbox_body_entered.
	#   pista: hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	pass

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta

	# TODO 1: moverse horizontalmente.
	#   pista: velocity.x = direccion_x * VELOCIDAD

	# TODO 2: dar vuelta cuando se sale del rango.
	#   pista: if position.x < x_min: direccion_x = 1.0
	#   pista: elif position.x > x_max: direccion_x = -1.0

	move_and_slide()

func _on_hurtbox_body_entered(body: Node) -> void:
	# body es el cuerpo que entro (deberia ser el jugador).
	# Si tiene el metodo recibir_dano, llamarlo.
	if body.has_method("recibir_dano"):
		body.recibir_dano()
