extends Sprite2D

# === DISOLVER CON CLIC (✅ demo — ya cableado) =============================
# Clic izquierdo: un tween sube el uniform "progreso" de 0 a 1 — el enemigo
# se quema. Otro clic: baja a 0 — revive. Es el mismo puente de la escena
# 10: set_shader_parameter / tween_property sobre el material.
#
# La parte del shader es TU ejercicio: shaders/exercises/disolver.gdshader.
# Hasta que la completes, el clic no cambia nada visible.
# ===========================================================================

var disuelto := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("event!")
		var mat := material as ShaderMaterial
		var destino := 0.0 if disuelto else 1.0
		disuelto = not disuelto
		var tween := create_tween()
		tween.tween_property(mat, "shader_parameter/progreso", destino, 1.2)
