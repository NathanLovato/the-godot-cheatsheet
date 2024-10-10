shader_type spatial;
render_mode cull_disabled;

uniform vec3 albedo_color : source_color;

uniform vec4 rim_light_color : source_color;
uniform float rim_light_intensity = 1.0;

#include "res://assets/shaders/fresnel.gdshaderinc"

void fragment() {
	ALBEDO = albedo_color;
	EMISSION = mix(ALBEDO, rim_light_color.rgb, rim_light_color.a) * clamp(smoothstep(0.55, 0.6, fresnel(1.0, NORMAL, VIEW)) * NORMAL.y, 0.0, 1.0) * rim_light_intensity;
}