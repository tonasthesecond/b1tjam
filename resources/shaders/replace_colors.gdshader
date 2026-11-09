shader_type canvas_item;

const int MAX_PAIRS = 8;

uniform sampler2D screen_tex: hint_screen_texture, filter_nearest;
uniform float tolerance: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform int pair_count: hint_range(0, 8) = 0;
uniform vec4 prev_colors[MAX_PAIRS]: source_color;
uniform vec4 new_colors[MAX_PAIRS]: source_color;

void fragment() {
    vec4 screen_color = texture(screen_tex, SCREEN_UV);

    int best_index = -1;
    float best_distance = tolerance;

    for (int i = 0; i < pair_count; i++) {
        float color_distance = distance(prev_colors[i], screen_color);
        if (color_distance <= best_distance) {
            best_distance = color_distance;
            best_index = i;
        }
    }

    vec4 out_color = screen_color;
    if (best_index >= 0) {
        out_color = mix(new_colors[best_index], screen_color, best_distance);
        out_color.a = screen_color.a;
    }

    COLOR = out_color;
}