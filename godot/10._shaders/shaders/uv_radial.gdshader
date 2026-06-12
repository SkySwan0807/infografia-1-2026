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
	COLOR = vec4(vec3(step(0.3, dist)), 1.0);
}
