extends PointLight2D

# === ANTORCHA QUE SIGUE AL MOUSE (✅ demo) =================================
# La luz se mueve con el mouse y su energía "tiembla" como una antorcha:
# dos senos de frecuencias distintas sumados — suficientemente irregular
# para parecer fuego, sin necesitar ruido de verdad.
# ===========================================================================

var tiempo := 0.0

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	tiempo += delta
	energy = 1.3 + sin(tiempo * 13.0) * 0.15 + sin(tiempo * 7.3) * 0.1
