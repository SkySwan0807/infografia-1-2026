extends Sprite2D

# === GOLPEAR AL SPRITE (✅ demo — el puente GDScript → shader) =============
# Al pulsar H este script escribe el uniform del shader con
# set_shader_parameter() y un tween lo regresa a 0. El shader es el que
# está a medio terminar (🔨 hit_flash.gdshader): hasta que en clase
# escribamos su línea, H no cambia nada en pantalla — aunque el valor SÍ
# se mueve (corre la escena desde el editor y mira el material).
#
# ⚠️ El gotcha de la escena: los DOS sprites comparten el MISMO
# ShaderMaterial — un recurso es compartido por defecto en Godot. Golpea
# "al de la izquierda" y... flashean los dos. Arreglos posibles:
#   · marcar el material como Local to Scene (resource_local_to_scene), o
#   · duplicarlo por instancia en _ready():  material = material.duplicate()
# Lo dejamos compartido A PROPÓSITO para que el problema se vea en clase.
# ===========================================================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("golpe"):
		golpear()

func golpear() -> void:
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("intensidad_flash", 1.0)
	var tween := create_tween()
	tween.tween_property(mat, "shader_parameter/intensidad_flash", 0.0, 0.3)
