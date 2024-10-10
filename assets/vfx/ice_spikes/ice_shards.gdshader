shader_type spatial;

uniform vec3 albedo : source_color;

void fragment() {
	ALBEDO = albedo;
}
