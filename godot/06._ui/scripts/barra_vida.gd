extends ProgressBar

# === BARRA DE VIDA (🔨 se completa EN VIVO en clase) ======================
# Esta barra no sabe de quién es la vida: le pasas el nodo Salud por el
# inspector y se conecta sola a su señal "vida_cambiada". El modelo avisa,
# la UI reacciona.
#
# Está casi lista: en _ready ya se conecta a la señal. Lo que falta es la
# REACCIÓN —el cuerpo de _on_vida_cambiada—, que escribimos juntos en clase.
# Hasta entonces la barra se queda llena aunque la vida baje (se nota: el
# cuadrado "pierde vida" pero la barra no se mueve).
# ==========================================================================

@export var nodo_salud: Node


func _ready() -> void:
	var salud := nodo_salud as Salud
	if salud == null:
		push_warning("BarraVida: falta asignar un nodo Salud en el inspector")
		return
	max_value = salud.vida_maxima
	value = salud.vida
	salud.vida_cambiada.connect(_on_vida_cambiada)


func _on_vida_cambiada(nueva_vida: int) -> void:
	# TODO (en vivo): haz que la barra refleje la vida.
	# La señal nos trae la vida nueva. La barra es un ProgressBar y su nivel
	# se controla con la propiedad "value". Es una sola línea.
	pass
