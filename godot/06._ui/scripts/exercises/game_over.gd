extends Control

# === PANTALLA DE GAME OVER (🎓 ejercicio) =================================
# Esta pantalla aparece cuando la vida llega a 0 (el HUD nos trajo acá con
# change_scene_to_file). Tiene dos botones ya conectados a estos métodos...
# pero los métodos todavía no hacen nada.
#
# Tu tarea: complétalos para que la navegación funcione:
#   - "Reintentar"      -> volver a jugar:  res://scenes/07_hud_vivo.tscn
#   - "Menú principal"  -> volver al menú:  res://scenes/05_menu_interactivo.tscn
#
# Pista: es lo mismo que hace el menú principal con "Jugar":
#   get_tree().change_scene_to_file("res://scenes/...")
# Solución en _solutions/game_over_solved.gd
# ==========================================================================


func _on_reintentar_pressed() -> void:
	pass # TODO: cambiar a la escena 07_hud_vivo.tscn


func _on_menu_principal_pressed() -> void:
	pass # TODO: cambiar a la escena 05_menu_interactivo.tscn
