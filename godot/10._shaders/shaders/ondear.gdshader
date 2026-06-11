shader_type canvas_item;

// === ONDEAR (✅ demo) ======================================================
// El OTRO programa del pipeline: vertex() corre una vez por VÉRTICE, antes
// que fragment(), y puede mover la GEOMETRÍA. VERTEX es la posición del
// vértice en pixeles locales.
//
// El detalle que importa: un Sprite2D es UN SOLO QUAD — tiene 4 vértices.
// Este shader sobre un sprite solo puede mover esas 4 esquinas (el sprite
// se tambalea). Sobre una malla SUBDIVIDIDA (muchos vértices) la misma
// fórmula produce una onda suave. Compáralo en la escena 09.
// ===========================================================================

uniform float amplitud : hint_range(0.0, 40.0) = 12.0;
uniform float frecuencia = 0.02;
uniform float velocidad = 3.0;

void vertex() {
	VERTEX.y += sin(TIME * velocidad + VERTEX.x * frecuencia) * amplitud;
}
