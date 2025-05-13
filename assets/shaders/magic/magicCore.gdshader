shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform sampler2D noise_tex : hint_default_white;
uniform vec4 magic_color : source_color = vec4(1.0, 0.3, 0.0, 1.0);
uniform float magic_alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec2 magic_speed = vec2(0.0, 1.5);
// controls the softness of the transition between the shape and the border color
uniform float border_feather : hint_range(0.0, 0.2) = 0.02;
// fades the outer edge of the whole shape smoothly into transparency
uniform float outer_feather : hint_range(0.0, 0.2) = 0.02;

// Mask inputs
uniform float size : hint_range(0.0, 1.0) = 0.5;
uniform int sides : hint_range(0, 50) = 6;
uniform float rotation : hint_range(-360.0, 360.0) = 0.0;
uniform float position_x : hint_range(-1.0, 1.5) = 0.5;
uniform float position_y : hint_range(-1.0, 1.5) = 0.5;
uniform float border_width : hint_range(0.0, 1.0) = 0.1;
uniform vec4 border_color : source_color = vec4(0.35, 0.35, 1.0, 1.0);
uniform bool maintain_aspect_ratio = true;

void fragment() {
    vec2 base_uv = UV;

    vec2 shifted_uv1 = base_uv + TIME * magic_speed;

    float noise1 = texture(noise_tex, fract(shifted_uv1)).r;
    float combined_noise = noise1;

    float shape = UV.y * ((UV.y * combined_noise) * 100.0);
    shape += sin(UV.y * 10.0 + TIME * 2.0) * 0.1;

    float gradient_pos = clamp(shape * 0.1, 0.2, 1.0);
    vec4 magic_col = magic_color;
    magic_col.a = clamp(shape, 0.0, 1.0) * magic_alpha;

	vec2 aspect_ratio = vec2(1.0, 1.0);
    if (maintain_aspect_ratio) {
        aspect_ratio = vec2(
            min(1.0, TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x),
            min(1.0, TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y)
        );
    }

    vec2 adjusted_uv = vec2(
        ((UV.x - position_x) * aspect_ratio.x) + 0.5,
        ((UV.y - position_y) * aspect_ratio.y) + 0.5
    );

    adjusted_uv = mix(vec2(-1.0), vec2(1.0), adjusted_uv);
    float theta = atan(adjusted_uv.y, adjusted_uv.x) + (rotation * PI / 180.0);
    float angle = TAU / float(sides);
    float half_angle = angle / 2.0;
    theta = mod(theta, angle) + half_angle;

    float corner_theta = atan(-aspect_ratio.y, -aspect_ratio.x);
    corner_theta = mod(corner_theta, angle) + half_angle;
    float corner_d = distance(vec2(0.0), -aspect_ratio);
    float max_radius = corner_d * cos(half_angle - abs(half_angle - corner_theta));
    float scale = size * max_radius;

    float polygon_radius = scale / cos(half_angle - abs(half_angle - theta));
    float border_scale = (size - border_width) * max_radius;
    float border_radius = border_scale / cos(half_angle - abs(half_angle - theta));
   	float d = distance(vec2(0.0, 0.0), adjusted_uv);

	float border_fade = smoothstep(border_radius, border_radius + border_feather, d);
	float outer_fade = 1.0 - smoothstep(polygon_radius - outer_feather, polygon_radius, d);

	if (d > polygon_radius) {
	    COLOR.a = 0.0;
	} else if (d > border_radius) {
	    // Inner border feathering (into border color)
	    vec4 modulated = vec4(border_color.rgb * border_color.a, 1.0);
		magic_col = mix(magic_col, modulated, border_color.a);
	    COLOR = mix(COLOR, modulated, border_fade * border_color.a);
	}

	// Outer edge alpha feather
	COLOR = magic_col;
	COLOR.a *= outer_fade;
	
}
