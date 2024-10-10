shader_type spatial;
render_mode particle_trails, cull_disabled;

void fragment() {
	float edge = sin(UV.x * PI) * sin(UV.y);
	ALBEDO = COLOR.rgb;
	ALPHA = step(0.25, edge) * (1.0 - UV.y) * COLOR.a;
	EMISSION = ALBEDO * 1.5;
}
