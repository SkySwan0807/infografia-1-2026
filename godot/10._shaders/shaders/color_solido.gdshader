shader_type canvas_item;

// === COLOR SÓLIDO (✅ demo) ================================================
// Tu primer shader. fragment() corre UNA VEZ POR CADA PIXEL del rectángulo,
// y todos los pixeles corren A LA VEZ, en el GPU. En rasterización (módulo
// 3.1) pintaste pixeles uno por uno con un for; acá no hay for: el GPU ya
// está "dentro" del for.
//
// Un fragment shader contesta una sola pregunta:
//   ¿de qué color es ESTE pixel?
// ===========================================================================

void fragment() {
	// COLOR es la salida: un vec4 (rojo, verde, azul, alfa), cada canal 0.0–1.0.
	// Todos los pixeles contestan lo mismo → un rectángulo sólido.
	COLOR = vec4(0.6, 0.7, 1.0, 1);
}
