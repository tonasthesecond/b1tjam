shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 8.0, 1.0) = 1.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec2 step_size = TEXTURE_PIXEL_SIZE * outline_width;

	// Highest alpha among the 4 neighbours.
	float neighbour_alpha = 0.0;
	neighbour_alpha = max(neighbour_alpha, texture(TEXTURE, UV + vec2(step_size.x, 0.0)).a);
	neighbour_alpha = max(neighbour_alpha, texture(TEXTURE, UV - vec2(step_size.x, 0.0)).a);
	neighbour_alpha = max(neighbour_alpha, texture(TEXTURE, UV + vec2(0.0, step_size.y)).a);
	neighbour_alpha = max(neighbour_alpha, texture(TEXTURE, UV - vec2(0.0, step_size.y)).a);

	// Outline only where this pixel is empty but a neighbour is solid.
	float outline = (1.0 - base.a) * neighbour_alpha;
	COLOR = mix(base, outline_color, outline);
}
