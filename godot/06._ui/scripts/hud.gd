extends Node2D

# === HUD VIVO (demo completo) =============================================
# El HUD ESCUCHA las señales del juego y actualiza sus widgets. Acá:
#   - un Timer que late cada segundo: sube los puntos, baja la vida, descuenta
#     el tiempo y refresca las etiquetas (PuntosLabel, TiempoLabel);
#   - la señal "vida_agotada" del nodo Salud: cuando la vida llega a 0,
#     saltamos a la pantalla de Game Over.
#
# La barra de vida reacciona por su cuenta (barra_vida.gd, conectada a
# "vida_cambiada"): el HUD ni la toca. Así se ve el patrón: cada widget
# escucha lo que le importa.
# ==========================================================================

@export var puntos_label: Label
@export var tiempo_label: Label
@export var nodo_salud: Salud
@export var reloj: Timer

var puntos := 0
var segundos := 10


func _ready() -> void:
	nodo_salud.vida_agotada.connect(_on_vida_agotada)
	reloj.timeout.connect(_on_reloj_timeout)
	reloj.start()
	_actualizar_labels()


func _on_reloj_timeout() -> void:
	puntos += 10
	segundos -= 1
	nodo_salud.recibir_dano(10)   # la vida baja sola: a sobrevivir
	_actualizar_labels()


func _actualizar_labels() -> void:
	puntos_label.text = "Puntos: %d" % puntos
	tiempo_label.text = "Tiempo: %d" % maxi(segundos, 0)


func _on_vida_agotada() -> void:
	get_tree().change_scene_to_file("res://scenes/08_game_over.tscn")
