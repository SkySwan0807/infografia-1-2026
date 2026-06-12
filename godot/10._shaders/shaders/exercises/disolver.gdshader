shader_type canvas_item;

// === DISOLVER (🎓 ejercicio) ===============================================
// El enemigo debe "quemarse" al hacer clic. Todo el cableado ya está hecho:
//   · ruido_tex es una NoiseTexture2D (nubes blanco/negro) asignada en el
//     material de la escena 11.
//   · progreso lo anima el script disolver_click.gd con un tween (clic =
//     0 → 1). Puedes verlo moverse en el inspector mientras corre.
// Pero el shader aún no usa nada de eso: clic y... no pasa NADA. Esa es tu
// señal de que falta tu línea.
//
// La idea: cada pixel tiene un valor de ruido (0 a 1). A medida que
// progreso sube, los pixeles cuyo ruido quedó POR DEBAJO ya se quemaron.
//   · Pista 1: discard; hace que el pixel no se dibuje (desaparece).
//   · Pista 2: compara el ruido de ESTE pixel con progreso.
//   · Pista 3: if (ruido < progreso) { ... } — una línea adentro.
//
// ¿Y si inviertes la comparación? Pruébalo: el sprite desaparece ENTERO al
// primer instante. Entender por qué = entender el efecto.
//
// Reto extra: justo antes de quemarse, pinta el borde de fuego:
//   if (ruido < progreso + 0.05) { COLOR.rgb = vec3(1.0, 0.5, 0.1); }
//   (ponlo DESPUÉS del discard: solo sobreviven los pixeles del borde).
//
// Solución en _solutions/disolver_solved.gdshader
// ===========================================================================

uniform sampler2D ruido_tex;
uniform float progreso : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float ruido = texture(ruido_tex, UV).r;

	// TODO: si el ruido de este pixel quedó por debajo de progreso, ya se
	// quemó: descártalo.

	COLOR = original;
}
