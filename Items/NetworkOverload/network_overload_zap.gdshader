shader_type canvas_item;

uniform float flash_speed = 2.0;
uniform float intensity = 1.5;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Create a flashing effect using sine wave
    float flash = abs(sin(TIME * flash_speed)) * intensity;

    // Blend flash color with texture
    COLOR = tex_color + flash * flash_color * tex_color.a;
}
