shader_type canvas_item;

// === LA BANDERA (🎓 ejercicio) =============================================
// Pinta la bandera de Bolivia: tres franjas horizontales (rojo arriba,
// amarillo al medio, verde abajo) y un círculo blanco suave en el centro.
// Ahora mismo el rectángulo sale MAGENTA: ese es el color de "no hice nada".
//
// Paso 1 — las franjas:
//   · Pista 1: UV.y te dice qué tan abajo está el pixel (0 arriba, 1 abajo).
//   · Pista 2: con if / else if / else sobre UV.y eliges un color por tercio.
//   · Pista 3: el primer tercio es  if (UV.y < 1.0 / 3.0) { ... }
//   ⚠️ Escribe 1.0 / 3.0, NO 1/3 — en shaders 1/3 es división ENTERA y vale 0.
//
// Paso 2 — el círculo:
//   · Pista 1: ya lo hiciste en la 02: distancia al centro + smoothstep.
//   · Pista 2: float dist = length(UV - vec2(0.5));
//   · Pista 3: mezcla hacia blanco:
//       color = mix(color, vec3(1.0), 1.0 - smoothstep(0.15, 0.19, dist));
//
// Reto extra: haz que el círculo "respire" con TIME — el radio sube y baja
// con sin(TIME) * 0.02.
//
// Solución en _solutions/bandera_solved.gdshader
// ===========================================================================

void fragment() {
	// TODO (paso 1): elige el color de la franja según UV.y.
	// TODO (paso 2): mezcla el círculo blanco encima.
	COLOR = vec4(1.0, 0.0, 1.0, 1.0);
}
