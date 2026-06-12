shader_type canvas_item;

// === EL MISMO SHADER, EN CÓDIGO (✅ demo) ==================================
// Este shader es el GEMELO EXACTO del grafo visual_radial.tres (el panel de
// la izquierda en la escena 03). Cada línea de acá es un nodo de allá:
// abre los dos en el editor y compáralos. El grafo y el código son DOS
// VISTAS del mismo shader; el GPU recibe lo mismo.
// ===========================================================================

void fragment() {
	vec2 desde_centro = UV - vec2(0.5);             // nodo Input(uv) + nodo VectorOp(resta)
	float dist = length(desde_centro);              // nodo VectorLen
	float t = smoothstep(0.1, 0.5, dist);           // nodo SmoothStep
	COLOR = vec4(vec3(t), 1.0);                     // nodo Output(Color)
}
