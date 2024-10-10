shader_type spatial;

uniform sampler2D mask_sampler : filter_linear_mipmap_anisotropic, repeat_disable;

uniform vec3 star_color : source_color;
uniform vec3 hat_color : source_color;
uniform vec3 band_color : source_color;

uniform vec4 rim_light_color : source_color;
uniform float rim_light_intensity = 1.0;

#include "res://assets/shaders/fresnel.gdshaderinc"

void fragment() {
	vec3 mask = texture(mask_sampler, UV).xyz;
	vec3 top_hat_color = mix(hat_color, star_color, mask.x);
	ALBEDO = mix(top_hat_color, band_color, mask.y + mask.z * 0.5);
	ROUGHNESS = mix(0.75, 0.5, mask.x);
	METALLIC = mask.x * 0.5;
	EMISSION = mix(ALBEDO, rim_light_color.rgb, rim_light_color.a) * clamp(smoothstep(0.55, 0.6, fresnel(1.0, NORMAL, VIEW)) * NORMAL.y, 0.0, 1.0) * rim_light_intensity;
}