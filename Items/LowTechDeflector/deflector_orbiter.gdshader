shader_type canvas_item;

uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec4 pulse_color : source_color = vec4(1.0, 0.3, 1.0, 1.0);

void fragment() {
    // Base texture
    vec4 tex = texture(TEXTURE, UV);

    // Time-based pulse (sin goes from -1 to 1)
    float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;

    // Create outward gradient from center of sprite
    vec2 uv_centered = UV - 0.5;
    float dist = length(uv_centered) * 2.0;

    // Invert so the center is stronger
    float mask = smoothstep(1.0, 0.0, dist);

    // Apply pulse strength
    float intensity = pulse * mask * pulse_strength;

    // Add glow-ish overlay
    COLOR = tex + (pulse_color * intensity);
    COLOR.a = tex.a; // preserve transparency
}
