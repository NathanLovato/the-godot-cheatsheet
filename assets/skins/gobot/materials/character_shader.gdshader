shader_type spatial;

uniform sampler2D albedo_sampler : filter_linear_mipmap, source_color, repeat_disable;
uniform sampler2D roughness_sampler : filter_linear_mipmap, hint_roughness_g, repeat_disable;
uniform sampler2D normal_sampler : filter_linear_mipmap, hint_normal, repeat_disable;

uniform float base_roughness = 1.0;

uniform vec4 rim_light_color : source_color;
uniform float rim_light_intensity = 1.0;

uniform vec4 emission_color : source_color;
uniform float emission_intensity = 0.0;

#include "res://assets/shaders/fresnel.gdshaderinc"

void fragment() {
	ALBEDO = mix(texture(albedo_sampler, UV).rgb, emission_color.rgb, emission_color.a);
	ROUGHNESS = texture(roughness_sampler, UV).y * base_roughness;
	NORMAL_MAP = texture(normal_sampler, UV).xyz;
	EMISSION = mix(ALBEDO, rim_light_color.rgb, rim_light_color.a) * clamp(smoothstep(0.55, 0.6, fresnel(1.0, NORMAL, VIEW)) * NORMAL.y, 0.0, 1.0) * rim_light_intensity;
	
	EMISSION += emission_color.rgb * emission_intensity;
}