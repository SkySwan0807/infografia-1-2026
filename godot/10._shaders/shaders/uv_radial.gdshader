shader_type canvas_item;

// === DEGRADADO RADIAL (✅ demo) ============================================
// length(UV - vec2(0.5)) = distancia de este pixel al CENTRO del rectángulo.
// smoothstep(a, b, d) convierte esa distancia en una rampa suave: vale 0.0
// si d < a, 1.0 si d > b, y sube suavecito entre medio.
//
// Distancia + rampa = círculos suaves, halos, viñetas. Lo vas a usar todo
// el módulo (y en el ejercicio de hoy).
// ===========================================================================

void fragment() {
	float dist = length(UV - vec2(0.5));
	float t = smoothstep(0.1, 0.5, dist);
	vec3 color_centro = vec3(1.0, 0.85, 0.3);
	vec3 color_borde = vec3(0.1, 0.1, 0.25);
	COLOR = vec4(mix(color_centro, color_borde, t), 1.0);
}
