shader_type spatial;

uniform sampler2D mask_sampler : filter_linear_mipmap_anisotropic, repeat_disable;

uniform vec3 star_color : source_color;
uniform vec3 body_color : source_color;

uniform vec4 rim_light_color : source_color;
uniform float rim_light_intensity = 1.0;

#include "res://assets/shaders/fresnel.gdshaderinc"

void fragment() {
	ALBEDO = mix(star_color, body_color, COLOR.x);
	EMISSION = mix(ALBEDO, rim_light_color.rgb, rim_light_color.a) * clamp(smoothstep(0.55, 0.6, fresnel(1.0, NORMAL, VIEW)) * NORMAL.y, 0.0, 1.0) * rim_light_intensity;
	EMISSION += ALBEDO * ((sin(TIME * 2.0) + 1.0) * 0.5) * COLOR.y;
}