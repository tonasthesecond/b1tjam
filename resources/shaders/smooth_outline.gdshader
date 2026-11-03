shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Outline thickness in texture pixels; fractional values allowed.
uniform float outline_width : hint_range(0.0, 8.0, 0.1) = 2;
// 0 = hard edge, 1 = fully soft falloff across the width.
uniform float softness : hint_range(0.0, 1.0, 0.01) = 0.7;

const int SAMPLES = 16;

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	// Look for solid pixels in rings around this pixel; nearer hits give a stronger outline.
	float strength = 0.0;
	for (int ring = 1; ring <= 3; ring++) {
		float dist = outline_width * float(ring) / 3.0;
		float falloff = 1.0 - softness * (float(ring) - 1.0) / 2.0;
		for (int i = 0; i < SAMPLES; i++) {
			float angle = TAU * float(i) / float(SAMPLES);
			vec2 offset = vec2(cos(angle), sin(angle)) * dist * TEXTURE_PIXEL_SIZE;
			strength = max(strength, texture(TEXTURE, UV + offset).a * falloff);
		}
	}

	float outline = (1.0 - base.a) * strength;
	COLOR = mix(base, vec4(outline_color.rgb, outline_color.a * outline), outline);
	COLOR.a = max(base.a, outline_color.a * outline);
}
