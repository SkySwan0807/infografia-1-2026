extends CanvasLayer

# === PAUSA + GRIS (✅ script completo; el 🔨 está en el shader) ============
# Esc alterna la pausa — módulo 9 puro: get_tree().paused congela el árbol,
# y este CanvasLayer sobrevive porque su process_mode es "Siempre" (si no,
# nadie escucharía el segundo Esc). Lo nuevo del módulo: al pausar también
# empujamos el uniform "cantidad" al shader de pantalla.
#
# El shader (pausa_gris.gdshader) aún no usa ese uniform: la desaturación
# se escribe EN VIVO en clase. Hasta entonces: pausa sí, gris no.
# ===========================================================================

@onready var rect: ColorRect = $Rect
@onready var aviso: Label = $Aviso

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		var pausado := not get_tree().paused
		get_tree().paused = pausado
		aviso.visible = pausado
		var mat := rect.material as ShaderMaterial
		mat.set_shader_parameter("cantidad", 1.0 if pausado else 0.0)
