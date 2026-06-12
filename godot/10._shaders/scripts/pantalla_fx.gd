extends ColorRect

# === SELECTOR DE EFECTO DE PANTALLA (✅ demo) ==============================
# Teclas 0 / 1 / 2 cambian el uniform "modo" del shader de pantalla:
#   0 = nada   1 = viñeta   2 = CRT
# Mismo puente de siempre: set_shader_parameter sobre el material.
# ===========================================================================

func _unhandled_key_input(event: InputEvent) -> void:
	var tecla := event as InputEventKey
	if tecla == null or not tecla.pressed or tecla.echo:
		return
	var mat := material as ShaderMaterial
	match tecla.keycode:
		KEY_0:
			mat.set_shader_parameter("modo", 0)
		KEY_1:
			mat.set_shader_parameter("modo", 1)
		KEY_2:
			mat.set_shader_parameter("modo", 2)
