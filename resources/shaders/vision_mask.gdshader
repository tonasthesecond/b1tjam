shader_type canvas_item;

// Everything farther than `radius` from the rect centre becomes `dark_color`;
// inside is transparent, so the world shows through untouched.
uniform vec4 dark_color : source_color = vec4(0.004, 0.008, 0.012, 1.0);
// In the rect's own units (game pixels); the owner script accounts for zoom.
uniform float radius = 96.0;
uniform vec2 rect_size = vec2(640.0, 480.0);
// Size of one game pixel in rect units; snaps the circle edge to the pixel grid.
uniform float pixel_size = 1.0;

void fragment() {
	vec2 offset = (UV - 0.5) * rect_size;
	offset = (floor(offset / pixel_size) + 0.5) * pixel_size;
	COLOR = length(offset) > radius ? dark_color : vec4(0.0);
}
