shader_type spatial;
render_mode diffuse_toon, specular_disabled;
uniform vec4 base_color : source_color = vec4(0.055, 0.07, 0.085, 1.0);
uniform vec4 crack_color : source_color = vec4(1.0, 0.005, 0.6, 1.0);
uniform float emission_strength = 0.0;
varying vec3 world_position;
void vertex() { world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
void fragment() {
	vec2 p = world_position.xy * 2.8 + world_position.z * vec2(0.4, 0.7);
	p += sin(p.yx * 1.7) * 0.22;
	vec2 cell = fract(p);
	float edge = min(min(cell.x, 1.0-cell.x), min(cell.y, 1.0-cell.y));
	float cracks = 1.0 - smoothstep(0.012, 0.038, edge);
	ALBEDO = base_color.rgb * (1.0 - cracks * 0.65);
	ROUGHNESS = 0.95;
	EMISSION = crack_color.rgb * cracks * emission_strength;
}
