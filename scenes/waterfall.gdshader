shader_type canvas_item;

uniform sampler2D frame_two : source_color, filter_nearest, repeat_enable;
uniform sampler2D noise_texture: source_color, filter_nearest, repeat_enable;

vec2 scroll_uv(vec2 uv, float speed) {
    return uv - vec2(0.0, TIME * speed);
}

void fragment() {
    // Sample both frames
    vec4 colorA = texture(TEXTURE, scroll_uv(UV, 0.2));   // frame 1 (the sprite's own texture)
    vec4 colorB = texture(frame_two, scroll_uv(UV, 0.1)); // frame 2
    float noise = texture(noise_texture, scroll_uv(UV, 0.15)).r;

    // Each pixel independently picks frame A or B
    COLOR = noise > 0.5 ? colorA : colorB;
}
