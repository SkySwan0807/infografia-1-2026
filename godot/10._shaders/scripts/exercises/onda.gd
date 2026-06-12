extends ColorRect

# === VIÑETA DE DAÑO (🎓 ejercicio — parte C) ===============================
# Las partes A y B viven en shaders/exercises/onda.gdshader. Acá va la
# parte C: cuando llega el golpe (H), empujar el uniform y dejar que un
# tween lo apague.
#
#   · Pista 1: es EXACTAMENTE lo que hace scripts/hit_flash.gd con su
#     uniform — míralo.
#   · Pista 2: mat.set_shader_parameter("intensidad", 1.0) y después un
#     tween que lleve "shader_parameter/intensidad" a 0.0 en ~0.4 s.
#
# Mientras falte cualquiera de las tres partes, H no hace nada visible.
# Solución en _solutions/onda_solved.gd
# ===========================================================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("golpe"):
		recibir_dano()

func recibir_dano() -> void:
	var mat := material as ShaderMaterial
	# TODO (parte C): sube "intensidad" a 1.0 y bájala a 0.0 con un tween.
	pass
