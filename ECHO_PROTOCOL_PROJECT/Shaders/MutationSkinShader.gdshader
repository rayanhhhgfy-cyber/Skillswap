shader_type spatial;

uniform sampler2D albedo_texture;
uniform sampler2D mutation_mask;
uniform float mutation_level : hint_range(0.0, 1.0);
uniform vec3 mutation_color : source_color = vec3(0.2, 0.0, 0.4); // Bruised Purple

void fragment() {
    vec4 base_tex = texture(albedo_texture, UV);
    float mask = texture(mutation_mask, UV).r;

    // As mutation rises, apply purple discoloration and black veins
    float effect_strength = clamp(mutation_level - mask, 0.0, 1.0);

    // Dynamic veins using a noise-like calculation (simulated)
    float veins = step(0.8, sin(UV.x * 50.0 + UV.y * 50.0 + mutation_level * 10.0));
    vec3 final_color = mix(base_tex.rgb, mutation_color, effect_strength);
    final_color = mix(final_color, vec3(0.0, 0.0, 0.0), veins * effect_strength); // Black veins

    ALBEDO = final_color;
    ROUGHNESS = 0.5 - (effect_strength * 0.3); // Slimier as it mutates
}
