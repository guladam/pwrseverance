shader_type canvas_item;
render_mode unshaded;

uniform vec3 color: source_color;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	COLOR = vec4(color, input_color.a);
}