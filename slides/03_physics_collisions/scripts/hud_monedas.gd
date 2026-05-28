# HUD: actualiza el texto del label cuando el jugador emite moneda_recolectada.
# La conexion de la senal se hace en el editor (ver el .tscn).

extends Label

func _on_moneda_recolectada(total: int) -> void:
	text = "Monedas: %d" % total
