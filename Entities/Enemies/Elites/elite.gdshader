shader_type canvas_item;

uniform float blur_size = 2.0;
uniform vec4 glow_color : source_color = vec4(0.0, 0.5, 1.0, 1.0); // Blue

void fragment() {
    vec4 sum = vec4(0.0);
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(x, y) * blur_size * TEXTURE_PIXEL_SIZE;
            sum += texture(TEXTURE, UV + offset);
        }
    }
    sum /= 25.0;
    COLOR = glow_color * sum.a;
}
