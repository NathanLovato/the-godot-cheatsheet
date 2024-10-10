shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 interior_albedo : source_color;

uniform vec4 rim_light_color : source_color;
uniform float rim_light_intensity = 1.0;

#include "res://assets/shaders/fresnel.gdshaderinc"
#include "res://assets/shaders/voronoi.gdshaderinc"

varying vec3 object_vertex;

void vertex() {
	object_vertex = VERTEX + float(INSTANCE_ID);
}

void fragment() {
	ALBEDO = mix(interior_albedo, albedo, smoothstep(0.0, 0.5, fresnel(1.0, NORMAL, VIEW)));
	EMISSION = mix(ALBEDO, rim_light_color.rgb, rim_light_color.a) * clamp(smoothstep(0.55, 0.6, fresnel(1.0, NORMAL, VIEW)) * NORMAL.y, 0.0, 1.0) * rim_light_intensity;
	float v = clamp(voronoi(object_vertex * vec3(2.0, 0.5, 2.0)).x, 0.0, 1.0);
	float mask = v - 0.5 + COLOR.a;
	ALPHA = round(mask);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
