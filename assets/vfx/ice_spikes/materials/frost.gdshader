shader_type spatial;

uniform vec3 albedo_1 : source_color;
uniform vec3 albedo_2 : source_color;
uniform sampler2D noise_sampler : filter_linear_mipmap;
uniform float offset : hint_range(0.0, 1.0, 0.1) = 0.0;
varying vec2 uv_offset;

void vertex() {
	uv_offset = NODE_POSITION_WORLD.xz;
}

void fragment() {
	vec2 uv = UV;
	uv = (uv - 0.5) * vec2(UV.y * 2.5, 1.0) + 0.5;
	float dist = distance(uv, vec2(0.5));
	float dist_mask = smoothstep(0.5, 0.0, dist);
	float base_noise = texture(noise_sampler, UV + uv_offset).x;
	float noise = base_noise - 0.5 + offset;
	ALBEDO = mix(albedo_1, albedo_2, noise);
	ALPHA = round(dist_mask - noise);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}