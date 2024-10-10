shader_type spatial;
render_mode shadows_disabled;

uniform sampler2D gradient_sampler : filter_linear, source_color, repeat_disable;
uniform sampler2D noise_sampler : filter_linear, repeat_disable;
uniform float uv_scale : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float energy = 1.0;
varying vec4 custom;

void vertex() {
	mat4 mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
	mat_world = mat_world * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float mask = texture(noise_sampler, UV * uv_scale + custom.z).x - 0.5 + custom.y;
	float dist = distance(UV, vec2(0.5));
	float dist_mask = smoothstep(0.45, 0.2, dist);
	vec3 gradient = texture(gradient_sampler, vec2(mask, 0.0)).rgb;
	ALBEDO = gradient;
	EMISSION = ALBEDO * energy;
	ALPHA = round(dist_mask - mask);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}