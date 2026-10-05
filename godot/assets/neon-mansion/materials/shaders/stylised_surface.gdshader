shader_type spatial;
render_mode diffuse_toon, specular_schlick_ggx;
uniform vec4 base_color : source_color = vec4(0.1, 0.2, 0.22, 1.0);
uniform int pattern : hint_range(0, 4) = 0;
uniform float roughness_value : hint_range(0, 1) = 0.8;
uniform float metallic_value : hint_range(0, 1) = 0.0;
uniform float pattern_scale = 1.0;
varying vec3 world_position;
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	vec4 v = fract(sin(vec4(dot(i, vec2(127.1,311.7)), dot(i+vec2(1,0), vec2(127.1,311.7)), dot(i+vec2(0,1), vec2(127.1,311.7)), dot(i+vec2(1,1), vec2(127.1,311.7)))) * 43758.5453);
	return mix(mix(v.x,v.y,f.x), mix(v.z,v.w,f.x),f.y);
}
void vertex() { world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
void fragment() {
	vec2 p = world_position.xz * pattern_scale;
	vec3 color = base_color.rgb;
	float roughness_local = roughness_value;
	if (pattern == 1) {
		vec2 f = fract(p);
		float edge = min(min(f.x, 1.0-f.x), min(f.y, 1.0-f.y));
		float grout = 1.0 - smoothstep(0.009, 0.018, edge);
		float checker = mod(floor(p.x) + floor(p.y), 2.0);
		color *= mix(0.85, 1.08, checker);
		color = mix(color, vec3(0.005, 0.008, 0.012), grout * 0.85);
		roughness_local = mix(roughness_value, 0.9, grout);
	} else if (pattern == 2) {
		float vein = pow(abs(sin(p.x * 3.0 + p.y * 1.8 + noise(p * 0.8) * 7.0)), 28.0);
		color = mix(color, base_color.rgb * 1.7, vein * 0.22);
		color *= 0.94 + noise(p * 0.5) * 0.12;
	} else if (pattern == 3) {
		// World-coordinate wood: restrained grain, no board labels or baked lighting.
		vec2 grain = vec2(world_position.x * 14.0 + world_position.y * 2.0, world_position.z * 0.7);
		color *= 0.84 + noise(grain * pattern_scale) * 0.28;
	} else if (pattern == 4) {
		color *= 0.92 + noise(vec2(world_position.x * 2.0, world_position.y * 70.0)) * 0.12;
	}
	ALBEDO = color;
	ROUGHNESS = roughness_local;
	METALLIC = metallic_value;
}
