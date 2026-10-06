shader_type spatial;
render_mode unshaded, fog_disabled, shadows_disabled, cull_disabled;
uniform sampler2D frame_a : source_color, filter_linear, repeat_disable;
uniform sampler2D frame_b : source_color, filter_linear, repeat_disable;
uniform float transition = 0.0;
void fragment() {
    ALBEDO = mix(texture(frame_a, UV).rgb, texture(frame_b, UV).rgb, transition);
    ALPHA = 1.0;
}
