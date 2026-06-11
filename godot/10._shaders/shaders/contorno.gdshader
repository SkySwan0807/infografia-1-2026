shader_type canvas_item;

// === CONTORNO (✅ demo) ====================================================
// Un pixel puede mirar a sus VECINOS: texture(TEXTURE, UV + desplazamiento)
// lee la textura en otra posición. TEXTURE_PIXEL_SIZE es cuánto mide un
// pixel de la textura en unidades UV — el paso exacto para moverse "un
// pixel" a la izquierda, derecha, arriba o abajo.
//
// La regla del contorno: si YO soy transparente pero algún vecino es opaco,
// estoy en el borde → me pinto del color del contorno.
// ===========================================================================

uniform vec4 color_contorno : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float grosor : hint_range(0.0, 8.0) = 2.0;

void fragment() {
	vec2 paso = TEXTURE_PIXEL_SIZE * grosor;
	vec4 original = texture(TEXTURE, UV);

	float alfa_arriba = texture(TEXTURE, UV + vec2(0.0, -paso.y)).a;
	float alfa_abajo = texture(TEXTURE, UV + vec2(0.0, paso.y)).a;
	float alfa_izq = texture(TEXTURE, UV + vec2(-paso.x, 0.0)).a;
	float alfa_der = texture(TEXTURE, UV + vec2(paso.x, 0.0)).a;

	bool soy_transparente = original.a < 0.1;
	bool vecino_opaco = alfa_arriba > 0.1 || alfa_abajo > 0.1 || alfa_izq > 0.1 || alfa_der > 0.1;

	if (soy_transparente && vecino_opaco) {
		COLOR = color_contorno;
	} else {
		COLOR = original;
	}
}
