shader_type canvas_item;

// === ESCALA DE GRISES (✅ demo) ============================================
// Primera vez que el shader LEE una textura: TEXTURE es la imagen del
// sprite, y texture(TEXTURE, UV) devuelve el color original de este pixel.
// A partir de ahí, matemática: la "luminancia" (qué tan claro se ve un
// color para el ojo) es un producto punto con pesos mágicos — el verde
// pesa más porque el ojo es más sensible al verde.
// ===========================================================================

uniform float fuerza : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float luminancia = dot(original.rgb, vec3(0.299, 0.587, 0.114));
	vec3 gris = vec3(luminancia);
	COLOR = vec4(mix(original.rgb, gris, fuerza), original.a);
}
