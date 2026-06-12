shader_type canvas_item;

// === TINTE (✅ demo) =======================================================
// El efecto más simple sobre una textura: multiplicar su color por otro.
// Blanco (1,1,1) deja el sprite igual; rojo lo "enrojece". Es lo que hace
// la propiedad modulate de los nodos... pero ahora sabes cómo se hace.
// ===========================================================================

uniform vec4 tinte : source_color = vec4(1.0, 0.45, 0.45, 1.0);

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	COLOR = vec4(original.rgb * tinte.rgb, original.a);
}
