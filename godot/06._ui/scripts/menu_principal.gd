extends Control

# === MENÚ PRINCIPAL (demo completo) ======================================
# Cada botón emite la señal "pressed" hacia ARRIBA; nosotros la recibimos
# acá y le pedimos al árbol (get_tree) que haga el trabajo: cambiar de escena
# o cerrar el juego.
#
# Regla mental del módulo: las SEÑALES suben (del botón a nosotros), las
# LLAMADAS bajan (nosotros le ordenamos al árbol / a los hijos).
#
# change_scene_to_file() reemplaza la escena actual por otra. Es la forma más
# simple de pasar de una pantalla a otra (menú -> juego -> game over).
# ==========================================================================


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/07_hud_vivo.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
