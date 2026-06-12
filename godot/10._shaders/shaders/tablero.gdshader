shader_type canvas_item;

// === TABLERO DE AJEDREZ (✅ demo) ==========================================
// floor() y mod(): la pareja que convierte coordenadas suaves en CELDAS.
//   floor(UV * 8.0)  → en qué celda (columna, fila) cae este pixel
//   mod(col + fila, 2.0) → alterna 0 / 1 como un tablero
// Es la grilla de siempre (la del flow field, la del tilemap)... pero
// calculada por pixel, sin nodos ni arrays.
// ===========================================================================

void fragment() {
	vec2 celda = floor(UV * vec2(8.0, 1.0));
	COLOR = vec4(vec3(mod(celda.x, 2.0)), 1.0);
}
