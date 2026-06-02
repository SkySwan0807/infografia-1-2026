extends Node2D

# === GAME MANAGER (PARA COMPLETAR EN CLASE 🔨 + 🎓) =======================
# El "cerebro" que integra todo. No tiene logica de juego propia: ESCUCHA
# señales (monedas, Health del player y del pet, Timer) y decide el resultado.
#
#   Ganas  : juntas todas las monedas.
#   Pierdes: se acaba el tiempo  O  muere tu personaje.
#
# Ya esta hecho: _start(), _process() (muestra el reloj) y _end().
# Falta CONECTAR las señales y escribir los handlers (ver los # TODO).
# Solucion de referencia: _solutions/game_manager_solved.gd
# ==========================================================================

@export var time_limit: int = 30
@export var player: CharacterBody2D
@export var pet: CharacterBody2D
@export var coins_container: Node2D
@export var score_label: Label
@export var timer_label: Label
@export var message_label: Label
@export var game_timer: Timer

var score: int = 0
var total_coins: int = 0
var game_over: bool = false


func _ready() -> void:
	total_coins = coins_container.get_child_count()

	# TODO 🔨 (en vivo): conectar las señales a sus handlers.
	#   - cada moneda de coins_container: coin.collected -> _on_coin_collected
	#   - game_timer.timeout            -> _on_time_up
	#   - Health del player (health_depleted) -> _on_player_died
	#   - Health del pet    (health_depleted) -> _on_pet_died
	#     pista: (player.get_node("Health") as Health).health_depleted.connect(...)

	_start()


func _start() -> void:
	score = 0
	game_over = false
	score_label.text = "Monedas: 0/%d" % total_coins
	message_label.hide()
	game_timer.start(time_limit)


func _process(_delta: float) -> void:
	if not game_over:
		timer_label.text = "Tiempo: %d" % int(ceil(game_timer.time_left))


func _on_coin_collected() -> void:
	# TODO 🔨: sumar 1 al score, actualizar score_label, y si score >= total_coins
	# terminar con victoria: _end("Ganaste!")
	pass


func _on_time_up() -> void:
	# TODO 🔨: derrota por tiempo.
	pass


func _on_player_died() -> void:
	# TODO 🔨: derrota porque cayo el jugador.
	pass


func _on_pet_died() -> void:
	# TODO 🎓: decide que pasa cuando muere el compañero.
	# Ideas: solo avisar y seguir / penalizar el tiempo / que tambien sea derrota.
	pass


func _end(msg: String) -> void:
	if game_over:
		return
	game_over = true
	game_timer.stop()
	message_label.text = msg
	message_label.show()
	get_tree().paused = true
