shader_type canvas_item;

uniform float flash_strength : hint_range(0.0, 1.0) = 0.0; // 0 = normal, 1 = full red

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Keep original alpha
    float alpha = tex_color.a;

    // Mix between normal and solid red
    vec3 red_tint = mix(tex_color.rgb, vec3(1.0, 0.0, 0.0), flash_strength);

    COLOR = vec4(red_tint, alpha);
}
