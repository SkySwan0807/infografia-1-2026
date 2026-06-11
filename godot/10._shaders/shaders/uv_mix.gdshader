shader_type canvas_item;

// === MEZCLAR DOS COLORES (✅ demo) =========================================
// mix(a, b, t) es LA herramienta de los shaders: con t = 0.0 devuelve a,
// con t = 1.0 devuelve b, y entre medio... la mezcla exacta. Si t = UV.x,
// la mezcla cambia a lo largo del rectángulo: un degradado.
// ===========================================================================

void fragment() {
	vec4 color_a = vec4(0.2, 0.4, 1.0, 1.0);
	vec4 color_b = vec4(1.0, 0.5, 0.1, 1.0);
	COLOR = mix(color_a, color_b, UV.x);
}
