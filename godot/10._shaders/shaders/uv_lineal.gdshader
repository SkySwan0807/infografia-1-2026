shader_type canvas_item;

// === UV: LA POSICIÓN DEL PIXEL (✅ demo) ===================================
// Si todos los pixeles corren el MISMO código, ¿cómo pintamos distinto a
// cada uno? Porque cada pixel sabe DÓNDE está: UV es su posición dentro del
// rectángulo, de (0,0) arriba-izquierda a (1,1) abajo-derecha.
//
// ⚠️ La Y crece hacia ABAJO (al revés que en la clase de mate).
// ===========================================================================

void fragment() {
	// El canal rojo crece con x, el verde con y. Mismo código, pixel distinto,
	// resultado distinto.
	COLOR = vec4(UV.x, UV.y, 0.0, 1.0);
}
