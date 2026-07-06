shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform vec2 viewport_size = vec2(1280.0, 720.0);
uniform vec2 camera_position = vec2(0.0, 0.0);
uniform vec2 camera_zoom = vec2(1.0, 1.0);
uniform float camera_rotation = 0.0;
uniform vec2 grid_origin = vec2(0.0, 0.0);
uniform float cell_size = 10.0;
uniform float min_pixels_between_cells = 3.0;
uniform float line_width_pixels = 1.0;
uniform float min_lod_power = -3.0;
uniform float max_lod_power = 4.0;
uniform bool debug_lod_colors = false;
uniform vec4 thin_line_color : source_color = vec4(0.30, 0.30, 0.30, 0.50);
uniform vec4 thick_line_color : source_color = vec4(0.42, 0.42, 0.42, 0.70);


vec2 rotate_2d(vec2 value, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	return vec2(c * value.x - s * value.y, s * value.x + c * value.y);
}


vec2 screen_to_world(vec2 screen_position) {
	vec2 safe_zoom = max(abs(camera_zoom), vec2(0.00001));
	vec2 centered_screen_position = screen_position - viewport_size * 0.5;
	return camera_position + rotate_2d(centered_screen_position / safe_zoom, camera_rotation);
}


float grid_line_alpha(vec2 uv, float current_cell_size) {
	vec2 coord = uv / current_cell_size;
	vec2 pixel_size = max(abs(dFdx(coord)) + abs(dFdy(coord)), vec2(0.00001));
	vec2 distance_to_line = min(fract(coord), 1.0 - fract(coord));
	vec2 distance_pixels = distance_to_line / pixel_size;

	float half_line_width_pixels = max(line_width_pixels, 0.25) * 0.5;
	vec2 coverage = 1.0 - smoothstep(
		vec2(max(half_line_width_pixels - 0.5, 0.0)),
		vec2(half_line_width_pixels + 0.5),
		distance_pixels
	);
	return max(coverage.x, coverage.y);
}


void fragment() {
	vec2 world_position = screen_to_world(FRAGCOORD.xy);
	vec2 uv = world_position - grid_origin;

	float safe_cell_size = max(cell_size, 0.00001);
	float min_power = min(min_lod_power, max_lod_power - 2.0);
	float max_power = max(max_lod_power, min_power + 2.0);
	float world_per_pixel = 1.0 / max(min(abs(camera_zoom.x), abs(camera_zoom.y)), 0.00001);
	float lod_level = log(max((world_per_pixel * min_pixels_between_cells) / safe_cell_size, 0.000001)) / log(10.0) + 1.0;
	float current_lod_power = clamp(floor(lod_level), min_power, max_power);
	float lod_fade = fract(clamp(lod_level, min_power, max_power));

	float lod0_power = clamp(current_lod_power, min_power, max_power);
	float lod1_power = clamp(current_lod_power + 1.0, min_power, max_power);
	float lod2_power = clamp(current_lod_power + 2.0, min_power, max_power);
	float lod0_cell_size = safe_cell_size * pow(10.0, lod0_power);
	float lod1_cell_size = safe_cell_size * pow(10.0, lod1_power);
	float lod2_cell_size = safe_cell_size * pow(10.0, lod2_power);

	float lod0_alpha = grid_line_alpha(uv, lod0_cell_size) * (1.0 - lod_fade);
	float lod1_alpha = grid_line_alpha(uv, lod1_cell_size);
	float lod2_alpha = grid_line_alpha(uv, lod2_cell_size);

	float lod2_visible_alpha = lod2_alpha;
	float lod1_visible_alpha = lod1_alpha * (1.0 - lod2_visible_alpha);
	float lod0_visible_alpha = lod0_alpha * (1.0 - lod1_alpha) * (1.0 - lod2_visible_alpha);

	vec4 lod0_color = thin_line_color;
	vec4 lod1_color = mix(thick_line_color, thin_line_color, lod_fade);
	vec4 lod2_color = thick_line_color;
	if (debug_lod_colors) {
		lod0_color = vec4(0.1, 0.35, 1.0, lod0_color.a);
		lod1_color = vec4(0.1, 1.0, 0.25, lod1_color.a);
		lod2_color = vec4(1.0, 0.15, 0.1, lod2_color.a);
	}

	float lod0_layer_alpha = lod0_visible_alpha * lod0_color.a;
	float lod1_layer_alpha = lod1_visible_alpha * lod1_color.a;
	float lod2_layer_alpha = lod2_visible_alpha * lod2_color.a;
	float line_alpha = clamp(lod0_layer_alpha + lod1_layer_alpha + lod2_layer_alpha, 0.0, 1.0);

	vec3 line_color = (
		lod0_color.rgb * lod0_layer_alpha +
		lod1_color.rgb * lod1_layer_alpha +
		lod2_color.rgb * lod2_layer_alpha
	) / max(line_alpha, 0.00001);

	COLOR = vec4(line_color, line_alpha);
	if (COLOR.a <= 0.001) {
		discard;
	}
}
