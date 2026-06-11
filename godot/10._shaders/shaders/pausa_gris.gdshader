shader_type canvas_item;

// === PAUSA EN GRIS (🔨 se completa EN VIVO) ================================
// Callback al módulo 9: Esc pausa el árbol (get_tree().paused) y el menú
// sobrevive por su process_mode. Lo nuevo: al pausar, la pantalla entera
// debería ponerse GRIS — el script ya empuja el uniform "cantidad" (0 ó 1),
// pero este shader todavía devuelve el frame tal cual.
//
// La línea que falta es la luminancia de gris.gdshader (sesión 2), aplicada
// al frame completo. Hasta escribirla: pausa sí, gris no — se nota.
// ===========================================================================

uniform sampler2D pantalla : hint_screen_texture, repeat_disable, filter_nearest;
uniform float cantidad : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 color = texture(pantalla, SCREEN_UV).rgb;
	// TODO (en vivo): desatura el frame según "cantidad" — dos líneas:
	//   float lum = dot(color, vec3(0.299, 0.587, 0.114));
	//   color = mix(color, vec3(lum), cantidad);
	COLOR = vec4(color, 1.0);
}
