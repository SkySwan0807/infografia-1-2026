shader_type canvas_item;

// === EFECTOS DE PANTALLA (✅ demo) =========================================
// Hasta ahora cada shader vivía en SU nodo. Este vive en un ColorRect que
// cubre la pantalla y puede LEER lo que el juego ya dibujó debajo:
//   hint_screen_texture  → "pantalla" es la imagen del frame
//   SCREEN_UV            → dónde estoy, en coordenadas de pantalla (0–1)
// Leer el frame + repintarlo = post-procesamiento. Todo lo de la sesión 1
// aplica, pero el "sprite" ahora es el juego entero.
// ===========================================================================

uniform sampler2D pantalla : hint_screen_texture, repeat_disable, filter_nearest;
// 0 = nada, 1 = viñeta, 2 = CRT (lo cambia el script con las teclas 0/1/2)
uniform int modo : hint_range(0, 2) = 1;

void fragment() {
	vec3 color = texture(pantalla, SCREEN_UV).rgb;

	if (modo == 1) {
		// viñeta: oscurecer los bordes — distancia al centro + smoothstep (¡la 02!)
		float dist = length(SCREEN_UV - vec2(0.5));
		float vineta = smoothstep(0.35, 0.75, dist);
		color = mix(color, vec3(0.0), vineta * 0.8);
	} else if (modo == 2) {
		// CRT: líneas de escaneo — una fila sí, una fila no (fract + step)
		float linea = step(0.5, fract(SCREEN_UV.y * 180.0));
		color *= mix(1.0, 0.7, linea);
		// y un tinte verdoso de monitor viejo
		color *= vec3(0.85, 1.0, 0.9);
	}

	COLOR = vec4(color, 1.0);
}
