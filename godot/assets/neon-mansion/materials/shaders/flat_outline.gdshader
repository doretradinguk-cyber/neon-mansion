shader_type spatial;
render_mode unshaded, fog_disabled, shadows_disabled, cull_disabled, depth_test_disabled, depth_draw_never;
// Full-screen pen-line pass for one camera. Ink is drawn wherever the fill colour,
// the surface plane or the surface angle changes, and along authored floor seams.
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest, repeat_disable;
uniform sampler2D depth_tex : hint_depth_texture, filter_nearest, repeat_disable;
uniform vec3 ink : source_color = vec3(0.0);
uniform float line_px = 2.0;
uniform float reference_width = 1376.0;
uniform float colour_threshold = 0.02;
uniform float crease_cosine = 0.95;
uniform float plane_tolerance = 0.012;
uniform mat4 gallery_from_world = mat4(1.0);
uniform float seam_x[4];
uniform int seam_x_count = 0;
uniform float seam_z[12];
uniform int seam_z_count = 0;

void vertex() { POSITION = vec4(VERTEX.xy, 1.0, 1.0); }

vec3 view_at(vec2 uv, mat4 inverse_projection) {
	vec4 view = inverse_projection * vec4(uv * 2.0 - 1.0, texture(depth_tex, uv).r, 1.0);
	return view.xyz / view.w;
}

vec3 normal_at(vec2 uv, vec2 px, vec3 centre, mat4 inverse_projection) {
	// Take each derivative from the neighbour on the same surface (smaller depth step).
	vec3 left = view_at(uv - vec2(px.x, 0.0), inverse_projection);
	vec3 right = view_at(uv + vec2(px.x, 0.0), inverse_projection);
	vec3 above = view_at(uv - vec2(0.0, px.y), inverse_projection);
	vec3 below = view_at(uv + vec2(0.0, px.y), inverse_projection);
	vec3 across = abs(left.z - centre.z) < abs(right.z - centre.z) ? centre - left : right - centre;
	vec3 down = abs(above.z - centre.z) < abs(below.z - centre.z) ? centre - above : below - centre;
	return normalize(cross(across, down));
}

int tile_at(vec3 view, mat4 inverse_view) {
	vec3 local = (gallery_from_world * inverse_view * vec4(view, 1.0)).xyz;
	if (abs(local.y) > 0.02) {
		return -1;
	}
	int tile = 0;
	for (int i = 0; i < seam_x_count; i++) {
		tile += local.x > seam_x[i] ? 1 : 0;
	}
	for (int i = 0; i < seam_z_count; i++) {
		tile += local.z > seam_z[i] ? 16 : 0;
	}
	return tile;
}

void fragment() {
	vec2 px = 1.0 / VIEWPORT_SIZE;
	float radius = max(1.0, round(line_px * VIEWPORT_SIZE.x / reference_width * 0.5));
	// Screen-border pixels test from just inside, so the frame edge never reads as a line.
	vec2 here = clamp(SCREEN_UV, px * (radius + 1.5), 1.0 - px * (radius + 1.5));
	vec3 centre = view_at(here, INV_PROJECTION_MATRIX);
	vec3 normal = normal_at(here, px, centre, INV_PROJECTION_MATRIX);
	int tile = tile_at(centre, INV_VIEW_MATRIX);
	vec3 colour = texture(screen_tex, here).rgb;
	bool edge = false;
	for (int i = 0; i < 8; i++) {
		float angle = float(i) * PI * 0.25;
		vec2 uv = here + round(vec2(cos(angle), sin(angle))) * radius * px;
		vec3 other = view_at(uv, INV_PROJECTION_MATRIX);
		int other_tile = tile_at(other, INV_VIEW_MATRIX);
		edge = edge || distance(texture(screen_tex, uv).rgb, colour) > colour_threshold;
		edge = edge || abs(dot(normal, other - centre)) > plane_tolerance * (1.0 + length(other - centre));
		edge = edge || dot(normal, normal_at(uv, px, other, INV_PROJECTION_MATRIX)) < crease_cosine;
		edge = edge || (tile >= 0 && other_tile >= 0 && tile != other_tile);
	}
	ALBEDO = edge ? ink : texture(screen_tex, SCREEN_UV).rgb;
}
