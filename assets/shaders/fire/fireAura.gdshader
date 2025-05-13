shader_type canvas_item;

// Fire effects
uniform sampler2D noise_tex : hint_default_white;
uniform vec4 bottom_color : source_color = vec4(0.0, 0.7, 1.0, 1.0);
uniform vec4 middle_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 top_color : source_color = vec4(1.0, 0.03, 0.001, 1.0);
uniform float fire_alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec2 fire_speed = vec2(0.0, 2.0);
uniform float fire_aperture : hint_range(0.0, 3.0) = 0.22;
// Fades the outer edge of the shape smoothly into transparency (on all 4 edges)
uniform float feather_fade : hint_range(0.0, 0.5) = 0.02;

vec4 tri_color_mix(vec4 color1, vec4 color2, vec4 color3, float pos) {
    pos = clamp(pos, 0.0, 1.0);
    if (pos < 0.5) {
        return mix(color1, color2, pos * 2.0);
    } else {
        return mix(color2, color3, (pos - 0.5) * 2.0);
    }
}

void fragment() {
    vec2 base_uv = UV;

    // Animate fire using noise
    vec2 shifted_uv1 = base_uv + TIME * fire_speed;
    vec2 shifted_uv2 = base_uv + TIME * fire_speed * 1.5;

    float fire_noise1 = texture(noise_tex, fract(shifted_uv1)).r;
    float fire_noise2 = texture(noise_tex, fract(shifted_uv2)).r;
    float combined_noise = (fire_noise1 + fire_noise2) * 0.5;

    float noise = UV.y * (((UV.y + fire_aperture) * combined_noise - fire_aperture) * 75.0);
    noise += sin(UV.y * 10.0 + TIME * 2.0) * 0.1;

    float gradient_pos = clamp(noise * 0.08, 0.3, 2.0);
    vec4 fire_color = tri_color_mix(bottom_color, middle_color, top_color, gradient_pos);

    // Feather fade on rectangular edges
    float fade_x = smoothstep(0.0, feather_fade, UV.x) * smoothstep(1.0, 1.0 - feather_fade, UV.x);
    float fade_y = smoothstep(0.0, feather_fade, UV.y) * smoothstep(1.0, 1.0 - feather_fade, UV.y);
    float feather = fade_x * fade_y;

    // Apply alpha with feather fade
    COLOR = fire_color;
    COLOR.a = clamp(noise, 0.0, 1.0) * fire_alpha * feather;
}
