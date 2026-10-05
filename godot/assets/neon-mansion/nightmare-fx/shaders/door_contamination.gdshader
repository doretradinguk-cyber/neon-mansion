shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;
uniform float seed = 0.0;
uniform bool access_panel = false;
void fragment() {
	vec2 p = UV;
	float tick = floor(TIME * 7.0 + seed);
	float band = step(0.93, fract(sin(floor(p.y * 22.0) + tick) * 43758.5453));
	vec2 cell = fract(p * vec2(5.0, 8.0) + sin(p.yx * 17.0 + seed) * 0.15);
	float edge = min(min(cell.x, 1.0-cell.x), min(cell.y, 1.0-cell.y));
	float crack = 1.0 - smoothstep(0.007, 0.025, edge);
	float scanline = step(0.83, fract(p.y * 70.0 + TIME * 2.0));
	vec3 signal = mix(vec3(1.0, 0.01, 0.55), vec3(0.0, 0.9, 1.0), step(0.5, fract(p.x * 7.0 + tick * 0.1)));
	float strength = max(crack * 0.65, band * 0.55);
	if (access_panel) {
		strength = max(strength, scanline * 0.6);
		signal = mix(signal, vec3(0.55, 1.0, 0.0), 0.35);
	}
	ALBEDO = signal * 1.8;
	EMISSION = signal * 1.8;
	ALPHA = strength;
}
