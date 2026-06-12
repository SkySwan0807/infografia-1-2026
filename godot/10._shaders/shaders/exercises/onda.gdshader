shader_type canvas_item;

// === VIÑETA DE DAÑO (🎓 ejercicio — partes A y B) ==========================
// Al pulsar H el jugador "recibe daño" y la pantalla debe pulsar una viñeta
// ROJA que se apaga sola. Es el ejercicio síntesis: el puente GDScript →
// uniform (escena 10) + shader de pantalla (escena 12).
//
// Parte A — el uniform:
//   · Pista 1: el script va a escribir un uniform llamado "intensidad".
//   · Pista 2: declárala como float con hint_range(0.0, 1.0) y valor 0.0.
//
// Parte B — la viñeta roja:
//   · Pista 1: es la viñeta de pantalla_fx.gdshader, pero hacia rojo y
//     multiplicada por intensidad.
//   · Pista 2: float dist = length(SCREEN_UV - vec2(0.5));
//              float borde = smoothstep(0.3, 0.7, dist);
//   · Pista 3: color = mix(color, vec3(0.8, 0.0, 0.0), borde * intensidad);
//
// (La parte C — empujar el uniform desde GDScript — está en
//  scripts/exercises/onda.gd.)
//
// Reto extra: que la viñeta LATA mientras está activa (sin(TIME * 20.0)).
// Solución en _solutions/onda_solved.gdshader
// ===========================================================================

uniform sampler2D pantalla : hint_screen_texture, repeat_disable, filter_nearest;

// TODO (parte A): declara acá el uniform float intensidad.

void fragment() {
	vec3 color = texture(pantalla, SCREEN_UV).rgb;
	// TODO (parte B): mezcla la viñeta roja según "intensidad".
	COLOR = vec4(color, 1.0);
}
