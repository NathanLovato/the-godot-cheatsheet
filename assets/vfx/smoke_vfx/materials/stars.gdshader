shader_type spatial;

uniform sampler2D shape_sampler : filter_linear_mipmap, repeat_disable;

void fragment() {
	ALBEDO = COLOR.rgb;
	EMISSION = ALBEDO;
	ALPHA = texture(shape_sampler, UV).a * COLOR.a;
}
