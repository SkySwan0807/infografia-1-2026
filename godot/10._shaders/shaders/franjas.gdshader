shader_type canvas_item;

// === FRANJAS + CÍRCULO (✅ demo) ===========================================
// Las dos herramientas del ejercicio de hoy, juntas:
//   · franjas: mod(UV.x * 6.0, 1.0) repite una rampa 0→1 seis veces, y
//     step(0.5, ...) la corta a la mitad → on/off, on/off...
//   · círculo suave: distancia al centro + smoothstep (como en la 02).
// Fíjate en el ORDEN: primero se decide el color de la franja, después se
// mezcla el círculo ENCIMA. Capas, como en un editor de imágenes.
// ===========================================================================

void fragment() {
	// capa 1: franjas verticales
	float franja = step(0.5, mod(UV.x * 6.0, 1.0));
	vec3 base = mix(vec3(0.2, 0.3, 0.5), vec3(0.9, 0.6, 0.2), franja);

	// capa 2: círculo suave encima
	float dist = length(UV - vec2(0.5));
	float circulo = 1.0 - smoothstep(0.18, 0.22, dist);
	vec3 color_final = mix(base, vec3(1.0), circulo);

	COLOR = vec4(color_final, 1.0);
}
