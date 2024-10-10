shader_type particles;
render_mode disable_velocity;

uniform int particles_count = 8;
uniform float min_radius = 0.5;
uniform float max_radius = 1.0;
uniform float min_scale = 1.0;
uniform float max_scale = 1.0;
uniform sampler2D alpha_curve : repeat_disable;
uniform sampler2D curve_sampler : repeat_disable;
uniform float sub_emitter_frequency;

#include "res://assets/shaders/rotate_x.gdshaderinc"
#include "res://assets/shaders/rotate_y.gdshaderinc"
#include "res://assets/shaders/rotate_z.gdshaderinc"
#include "res://assets/shaders/remap.gdshaderinc"

float rand_from_seed(in uint seed) {
	int k;
	int s = int(seed);
	if (s == 0) s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0) s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

mat4 get_position(mat4 t, vec4 custom, float percent) {
	float half_pi = PI / 2.0;
	float circle_angle = 0.8;
	float half_custom_x = (custom.x - 0.5) * 2.0;
	float angle = half_pi + half_custom_x * circle_angle;
	float side_angle = half_custom_x * circle_angle;
	float radius = max(min_radius, percent * max_radius);
	// x elevation
	// y scale
	vec2 animation = texture(curve_sampler, vec2(custom.y, 0.0)).xy;
	mat3 rot = rotateY(side_angle) * rotateX(-1.0 * percent) * rotateY(custom.x);
	float base_scale = remap((1.0 - abs(half_custom_x)) * percent, 0.0, 1.0, min_scale, max_scale) * animation.y;
	t[0] *= base_scale; 
	t[1] *= base_scale;
	t[2] *= base_scale;
	t[3].xyz = vec3(
		cos(angle) * radius,
		0.0,
		sin(angle) * radius);
	vec3 offset = vec3(0.0, animation.x, 0.0);
	t *= mat4(rot);
	t[3].xyz += rot * offset;
	return t;
}

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(2) + RANDOM_SEED);
	CUSTOM.x = rand_from_seed(alt_seed1);
	CUSTOM.y = 0.0;
	TRANSFORM = EMISSION_TRANSFORM;
	float percent = float(INDEX) / float(particles_count);
	TRANSFORM = get_position(TRANSFORM, CUSTOM, percent);
}

void process() {
	CUSTOM.y += DELTA / LIFETIME;
	CUSTOM.y = clamp(CUSTOM.y, 0.0, 1.0);
	float percent = float(INDEX) / float(particles_count);
	TRANSFORM = EMISSION_TRANSFORM;
	TRANSFORM = get_position(TRANSFORM, CUSTOM, percent);
	
	COLOR.a = texture(alpha_curve, vec2(CUSTOM.y, 0.0)).x;
 
	if(CUSTOM.y > 0.8 && CUSTOM.y < 0.99){
		int emit_count = 0;
		float interval_from = CUSTOM.y * LIFETIME - DELTA;
		float interval_rem = sub_emitter_frequency - mod(interval_from,sub_emitter_frequency);
		if (DELTA >= interval_rem) emit_count = 1;
		for(int i=0;i<emit_count;i++) {
			uint flags = FLAG_EMIT_POSITION;
			emit_subparticle(TRANSFORM,VELOCITY,vec4(0.0),vec4(0.0),flags);
		}
	}

}
