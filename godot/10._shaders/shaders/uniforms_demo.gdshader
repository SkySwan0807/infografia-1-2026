shader_type canvas_item;

// === UNIFORMS: PERILLAS PARA EL INSPECTOR (🔨 se completa EN VIVO) =========
// Este shader funciona... pero sus números viven enterrados en el código.
// Un `uniform` saca una variable al INSPECTOR: la mueves con el mouse y el
// efecto cambia en vivo, sin tocar el código. Y desde GDScript se puede
// escribir con set_shader_parameter() — eso llega en la sesión 2.
//
// En clase convertimos las constantes de abajo en uniforms:
//
//   uniform vec3 color_circulo : source_color = vec3(1.0, 0.85, 0.3);
//   uniform float radio : hint_range(0.0, 0.7) = 0.25;
//
// Los "hints" le dicen al inspector qué perilla dibujar: source_color pone
// un selector de color, hint_range(min, max) pone un deslizador.
// Después: clic en el ColorRect → Material → y las perillas aparecen solas.
// ===========================================================================

// TODO (en vivo): declara acá arriba los uniforms color_circulo y radio.

void fragment() {
	// TODO (en vivo): borra estas dos constantes para que el shader use los
	// uniforms (mismos nombres: no hay que tocar nada más abajo).
	vec3 color_circulo = vec3(1.0, 0.85, 0.3);
	float radio = 0.25;

	float dist = length(UV - vec2(0.5));
	float t = smoothstep(radio, radio + 0.05, dist);
	COLOR = vec4(mix(color_circulo, vec3(0.1, 0.1, 0.25), t), 1.0);
}
