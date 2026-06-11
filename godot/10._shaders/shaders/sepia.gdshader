shader_type canvas_item;

// === SEPIA (✅ demo) =======================================================
// Igual que la escala de grises, pero el gris se tiñe: cada canal de la
// luminancia se multiplica por un tono cálido. Compara con gris.gdshader:
// cambia UNA línea y el efecto es otro.
// ===========================================================================

uniform float fuerza : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float luminancia = dot(original.rgb, vec3(0.299, 0.587, 0.114));
	vec3 tono_sepia = vec3(luminancia * 1.0, luminancia * 0.95, luminancia * 0.75);
	COLOR = vec4(mix(original.rgb, tono_sepia, fuerza), original.a);
}
