shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 0.5;
uniform float width : hint_range(0.01, 0.5) = 0.15;
uniform vec4 shimmer_color : source_color = vec4(1.0, 1.0, 1.0, 0.8);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Diagonal shimmer line
    float line = fract(UV.x + UV.y + TIME * speed);

    // Control sharpness and width
    float mask = smoothstep(0.0, width, line) * (1.0 - smoothstep(width, width * 2.0, line));

    // Multiply shimmer by texture alpha, so shimmer only appears where art exists
    mask *= tex_color.a;

    // Mix shimmer with coin art
    COLOR = tex_color + shimmer_color * mask;
}
