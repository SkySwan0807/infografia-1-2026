extends Node2D

# === CUADRADO QUE REBOTA (demo completo) ==================================
# No tiene nada de UI: está acá solo para DEMOSTRAR la pausa. Cuando el árbol
# se pausa (get_tree().paused = true), este _process deja de correr y el
# cuadrado se congela. El menú de pausa, en cambio, sigue vivo porque su
# process_mode es "Cuando se pausa" / "Siempre".
#
# La clave: este nodo es PAUSABLE (se pausa con el árbol). El menú no.
# ==========================================================================

var velocidad := Vector2(260, 190)


func _process(delta: float) -> void:
	position += velocidad * delta
	var limite := get_viewport_rect().size - Vector2(30, 30)
	if position.x < 30 or position.x > limite.x:
		velocidad.x = -velocidad.x
	if position.y < 30 or position.y > limite.y:
		velocidad.y = -velocidad.y
	position = position.clamp(Vector2(30, 30), limite)
