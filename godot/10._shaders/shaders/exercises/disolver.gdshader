shader_type canvas_item;

// === DISOLVER — SOLUCIÓN (solo docente) ====================================
// Para verificar: copia este archivo sobre shaders/exercises/disolver.gdshader
// y corre la escena 11. Clic = el enemigo se quema con borde de fuego.
// ===========================================================================

uniform sampler2D ruido_tex;
uniform float progreso : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float ruido = texture(ruido_tex, UV).r;

	// la línea del ejercicio: el pixel cuyo ruido quedó por debajo ya se quemó
	if (ruido < progreso) {
		discard;
	}

	COLOR = original;

	// reto extra: borde de fuego justo antes de quemarse (después del discard
	// solo sobreviven los pixeles del borde)
	if (ruido < progreso + 0.05) {
		COLOR.rgb = vec3(1.0, 0.5, 0.1);
	}
}
