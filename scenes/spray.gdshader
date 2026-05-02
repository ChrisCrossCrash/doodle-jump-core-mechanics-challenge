shader_type canvas_item;

uniform sampler2D frame_two : source_color, filter_nearest;
uniform float dither_speed : hint_range(0.0, 60.0) = 10.0;
uniform float density : hint_range(0.0, 1.0) = 0.0;

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
    vec2 screen_size = vec2(135.0, 240.0);
    vec2 pixel_coord = floor(UV * screen_size);
    vec2 uv_pixelated = pixel_coord / screen_size;

    float t = floor(TIME * dither_speed);

    // Use a separate hash sample for the discard test so it's
    // independent of the frame-swap dither.
    float discard_n = hash(pixel_coord + vec2(t * 2.3, t * 4.1));
    if (discard_n > density) {
        discard;
    }

    float n = hash(pixel_coord + vec2(t, t * 1.7));
    COLOR = n > 0.5 ? COLOR : texture(frame_two, uv_pixelated);
}