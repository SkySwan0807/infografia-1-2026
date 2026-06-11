shader_type canvas_item;

// === CALOR (✅ demo) =======================================================
// La misma idea del agua con otra receta: cada FILA de pixeles se corre un
// poquito a la izquierda o a la derecha según un seno que viaja con TIME.
// Es el "aire caliente" sobre el fuego, o un espejismo de carretera.
// ===========================================================================

uniform float magnitud : hint_range(0.0, 0.1) = 0.015;
uniform float frecuencia = 25.0;
uniform float velocidad = 3.0;

void fragment() {
	vec2 uv = UV;
	uv.x += sin(uv.y * frecuencia + TIME * velocidad) * magnitud;
	COLOR = texture(TEXTURE, uv);
}
