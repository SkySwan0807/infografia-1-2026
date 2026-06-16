shader_type canvas_item;

// === PASTO (✅ demo) =======================================================
// Vaivén con ANCLA: la punta se mece, la base no se mueve. El truco es que
// el desplazamiento se multiplica por la "altura" del vértice: los vértices
// de abajo (la raíz) se desplazan 0, los de arriba (la punta) se desplazan
// a pleno. En local, el centro es (0,0) y arriba es Y NEGATIVA.
// ===========================================================================

uniform float fuerza : hint_range(0.0, 1.0) = 0.35;
uniform float velocidad = 2.0;

void vertex() {
	// altura: 0 en el centro/base, crece hacia arriba (recuerda: -Y es arriba)
	float altura = max(-VERTEX.y, 0.5);
	VERTEX.x += sin(TIME * velocidad) * altura * fuerza;
}
