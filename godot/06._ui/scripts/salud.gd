extends Node
class_name Salud

# === COMPONENTE DE VIDA (demo completo) ===================================
# Lleva la cuenta de la vida y AVISA con señales cuando cambia. No sabe nada
# de barras ni de pantallas: el que decide qué hacer cuando la vida cambia es
# quien escuche la señal (la barra de vida, el HUD...).
#
# Es el mismo patrón del módulo del companion: el modelo avisa, la UI reacciona.
# La señal SUBE; la UI que la escucha reacciona.
# ==========================================================================

signal vida_cambiada(nueva_vida: int)
signal vida_agotada

@export var vida_maxima: int = 100
var vida: int


func _ready() -> void:
	vida = vida_maxima


func recibir_dano(cantidad: int) -> void:
	vida = clampi(vida - cantidad, 0, vida_maxima)
	vida_cambiada.emit(vida)
	if vida == 0:
		vida_agotada.emit()
