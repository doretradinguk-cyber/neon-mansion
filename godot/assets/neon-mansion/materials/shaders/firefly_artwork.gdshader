shader_type spatial;
render_mode unshaded, cull_disabled;
uniform int artwork_index = 0;
void fragment() {
    vec2 p = UV;
    vec3 color = vec3(0.008, 0.012, 0.016);
    // Dark matte surrounds landscape art inside the existing portrait frame.
    if (p.y > 0.26 && p.y < 0.74 && p.x > 0.035 && p.x < 0.965) {
        p.y = (p.y - 0.26) / 0.48;
        color = mix(vec3(0.025, 0.07, 0.075), vec3(0.065, 0.018, 0.08), p.y);
        float moon = 1.0 - smoothstep(0.13, 0.14, length((p - vec2(0.7, 0.3)) * vec2(1.72, 1.0)));
        color = mix(color, vec3(0.24, 0.075, 0.19), moon);
        if (artwork_index == 0) {
            float roof = 0.50 - 0.2 * (1.0 - abs(p.x - 0.5) * 4.0);
            bool mansion = p.x > 0.23 && p.x < 0.77 && p.y > roof;
            bool towers = (abs(p.x - 0.25) < 0.045 || abs(p.x - 0.75) < 0.045) && p.y > 0.3;
            if (mansion || towers) color = vec3(0.009, 0.022, 0.026);
            float windows = step(0.78, fract(p.x * 18.0)) * step(0.72, fract(p.y * 8.0));
            if (mansion && p.y > 0.52 && p.y < 0.83) color += windows * vec3(0.025, 0.12, 0.11);
        } else if (p.y > 0.54) {
            float grid = step(0.96, fract(p.x * 12.0)) + step(0.94, fract((p.y - 0.54) * 14.0));
            color = vec3(0.012, 0.016, 0.025) + min(grid, 1.0) * vec3(0.14, 0.012, 0.085);
        }
    }
    ALBEDO = color;
}
