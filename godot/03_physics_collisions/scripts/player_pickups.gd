# Jugador del demo 03: gravedad + salto (del demo 02) + dos metodos
# publicos que las Area2D externas le llaman.
#
# sumar_moneda() y recibir_dano() son los puntos de entrada que usan
# las monedas y las puas. Cada Area2D detecta al jugador, busca al
# objeto y llama al metodo correspondiente.

extends CharacterBody2D

const GRAVEDAD: float = 1200.0
const VELOCIDAD_HORIZONTAL: float = 280.0
const VELOCIDAD_SALTO: float = -520.0

signal moneda_recolectada(total: int)
signal jugador_danado

var posicion_inicial: Vector2 = Vector2.ZERO
var monedas: int = 0

func _ready() -> void:
	posicion_inicial = position

func _physics_process(delta: float) -> void:
	velocity.y += GRAVEDAD * delta

	var dir := Input.get_axis("izquierda", "derecha")
	velocity.x = dir * VELOCIDAD_HORIZONTAL

	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = VELOCIDAD_SALTO

	move_and_slide()

func sumar_moneda() -> void:
	monedas += 1
	moneda_recolectada.emit(monedas)

func recibir_dano() -> void:
	position = posicion_inicial
	velocity = Vector2.ZERO
	monedas = 0
	moneda_recolectada.emit(monedas)
	jugador_danado.emit()
