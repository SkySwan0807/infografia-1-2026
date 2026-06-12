extends CanvasLayer

# === MENÚ DE PAUSA (demo completo) ========================================
# Este nodo (el menú) tiene process_mode = "Siempre" (ALWAYS) en el inspector,
# así que su código corre AUNQUE el árbol esté pausado. Por eso puede:
#   - escuchar la tecla Esc para pausar / despausar, y
#   - responder a sus botones mientras el juego está congelado.
#
# get_tree().paused = true congela TODO el árbol... menos los nodos cuyo
# process_mode sea "Siempre" o "Cuando se pausa". El cuadrado (mover.gd) es
# PAUSABLE, así que se congela. Este menú no.
# ==========================================================================


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		_alternar_pausa()


func _alternar_pausa() -> void:
	var en_pausa := not get_tree().paused
	get_tree().paused = en_pausa
	visible = en_pausa


func _on_continuar_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_menu_principal_pressed() -> void:
	# Despausar ANTES de cambiar de escena: "paused" es del árbol, no de la
	# escena. Si no lo apagamos, la escena nueva nacería congelada.
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/05_menu_interactivo.tscn")
