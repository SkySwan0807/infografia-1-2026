shader_type canvas_item;

// === TABLERO DE AJEDREZ (✅ demo) ==========================================
// floor() y mod(): la pareja que convierte coordenadas suaves en CELDAS.
//   floor(UV * 8.0)  → en qué celda (columna, fila) cae este pixel
//   mod(col + fila, 2.0) → alterna 0 / 1 como un tablero
// Es la grilla de siempre (la del flow field, la del tilemap)... pero
// calculada por pixel, sin nodos ni arrays.
// ===========================================================================

void fragment() {
	vec2 celda = floor(UV * 8.0);
	float alterna = mod(celda.x + celda.y, 2.0);
	vec3 oscuro = vec3(0.15, 0.15, 0.2);
	vec3 claro = vec3(0.85, 0.85, 0.8);
	COLOR = vec4(mix(oscuro, claro, alterna), 1.0);
}
