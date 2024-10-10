shader_type spatial;
render_mode shadows_disabled, cull_back;

uniform vec3 albedo : source_color;

varying float voronoi_value;

uniform float progress = 0.0;
uniform float smoothness = 0.01;

uniform float ease = 2.0;
uniform float base_scale = 1.0;
uniform float deformation_scale = 1.0;

uniform float texture_offset = 0.0;

#include "res://assets/shaders/voronoi.gdshaderinc"
#include "res://assets/shaders/fresnel.gdshaderinc"

void vertex() {
	float smooth_df = deformation_scale;
	voronoi_value = voronoi(VERTEX + texture_offset).x;
	VERTEX += NORMAL * (1.0 - pow(voronoi_value, ease)) * smooth_df;
	VERTEX *= base_scale;
}

void fragment(){
	ALBEDO = albedo;
	EMISSION = albedo * 0.5;
	ALPHA = 1.0 - fresnel(1.0, NORMAL, VIEW);
	ALPHA *= smoothstep(progress - smoothness, progress + smoothness, voronoi_value);
	//ALPHA_SCISSOR_THRESHOLD = 0.5;
}
