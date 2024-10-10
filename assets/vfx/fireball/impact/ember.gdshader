shader_type spatial;

uniform sampler2D mask_sampler : filter_linear, repeat_disable;
varying vec4 custom;

void vertex() {
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb * 1.2;
	ALPHA = texture(mask_sampler, UV).x * COLOR.a;
}
