shader_type canvas_item;

// === PIXELAR (✅ demo) =====================================================
// floor() otra vez (¿te suena del tablero?): redondear las UV a una grilla
// hace que TODOS los pixeles de una celda lean el MISMO punto de la
// textura → mosaico. Sube tamano_pixel y el sprite se "retro-fica".
// ===========================================================================

uniform float tamano_pixel : hint_range(0.005, 0.2) = 0.05;

void fragment() {
	vec2 uv_grilla = floor(UV / tamano_pixel) * tamano_pixel;
	COLOR = texture(TEXTURE, uv_grilla);
}
