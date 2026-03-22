shader_type spatial;

uniform sampler2D albedo_texture;
uniform sampler2D mutation_mask;
uniform float mutation_level : hint_range(0.0, 1.0);
uniform vec3 mutation_color : source_color = vec3(0.2, 0.0, 0.4); // Bruised Purple
uniform bool is_frozen = false;
uniform float time_offset = 0.0;

void fragment() {
    if (is_frozen) {
        ALBEDO = vec3(0.5, 0.7, 1.0); // Frozen blue tint
        ALPHA = 0.8;
        return;
    }

    vec4 base_tex = texture(albedo_texture, UV);
    float mask = texture(mutation_mask, UV).r;

    // Threshold based mutation application
    float mutation_influence = clamp((mutation_level - mask) * 2.0, 0.0, 1.0);

    // Pulse effect for veins (biological horror feel)
    float pulse = (sin(TIME * 2.0 + (UV.x + UV.y) * 10.0) + 1.0) * 0.5;

    // Complex vein simulation using scrolling textures
    float vein_pattern = step(0.9, sin(UV.x * 100.0 + UV.y * 100.0 + TIME * 0.1));
    float vein_influence = vein_pattern * mutation_influence * (0.8 + 0.2 * pulse);

    vec3 skin_color = mix(base_tex.rgb, mutation_color, mutation_influence);
    vec3 final_color = mix(skin_color, vec3(0.0, 0.0, 0.0), vein_influence);

    ALBEDO = final_color;

    // Shiny, wet look for high mutation
    SPECULAR = 0.2 + mutation_influence * 0.5;
    ROUGHNESS = 0.5 - mutation_influence * 0.3;

    // Slight subsurface scattering look
    EMISSION = mutation_color * (mutation_influence * 0.1 * pulse);
}
