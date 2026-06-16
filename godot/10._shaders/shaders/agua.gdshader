shader_type canvas_item;

// === AGUA (✅ demo) ========================================================
// Distorsión: en vez de cambiar el COLOR, cambiamos DÓNDE leemos la
// textura. Una onda senoidal que depende de la distancia al centro y de
// TIME desplaza las UV → la imagen ondula como bajo el agua.
//
// TIME es el reloj del shader: segundos desde que arrancó, siempre subiendo.
// ===========================================================================

uniform float velocidad = 2.0;
uniform float magnitud : hint_range(0.0, 0.2) = 0.04;
uniform float frecuencia = 12.0;

void fragment() {
	float dist = distance(UV, vec2(0.5, 0.65));
	float onda = sin(dist * frecuencia - TIME * velocidad);
	vec2 uv_distorsionada = UV + vec2(onda) * magnitud;
	COLOR = texture(TEXTURE, uv_distorsionada);
}
