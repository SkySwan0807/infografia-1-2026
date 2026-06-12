shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(UV.y, UV.y, UV.y, 1);
}
