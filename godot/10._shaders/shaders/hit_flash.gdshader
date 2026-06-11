shader_type canvas_item;

// === HIT FLASH (🔨 se completa EN VIVO) ====================================
// EL PUENTE entre el juego y el shader: un uniform también se puede
// escribir desde GDScript con set_shader_parameter(). El script de la
// escena ya lo hace — al pulsar H, sube intensidad_flash a 1.0 y un tween
// la baja a 0.0. Pero este shader todavía IGNORA el uniform: por eso H no
// hace nada visible... hasta que escribamos la línea en clase.
//
// La línea que falta mezcla el color original hacia BLANCO según la
// intensidad — el clásico "recibí daño" de todos los juegos.
// ===========================================================================

uniform float intensidad_flash : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	// TODO (en vivo): mezcla hacia blanco con intensidad_flash — una línea:
	//   original.rgb = mix(original.rgb, vec3(1.0), intensidad_flash);
	COLOR = original;
}
