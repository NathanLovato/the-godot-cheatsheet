shader_type particles;
render_mode collision_use_scale;

uniform float min_scale = 0.5;
uniform float max_scale = 1.0;
uniform float collision_friction = 0.5;
uniform float collision_bounce = 0.5;
uniform sampler2D scale_curve : repeat_disable;

#include "res://assets/shaders/remap.gdshaderinc"
#include "res://assets/shaders/rotate_z.gdshaderinc"

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

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(10) + RANDOM_SEED);

	CUSTOM.x = rand_from_seed(alt_seed1);
	CUSTOM.y = 0.0;
	VELOCITY = vec3((rand_from_seed(alt_seed2) - 0.5) * 4.0, 2.0, CUSTOM.x * 4.0);
}

void process() {
	CUSTOM.y += DELTA / LIFETIME;
	VELOCITY.y -= 0.25;
	if (COLLIDED) {
		if (length(VELOCITY) > 3.0) {
			TRANSFORM[3].xyz += COLLISION_NORMAL * COLLISION_DEPTH;
			VELOCITY -= COLLISION_NORMAL * dot(COLLISION_NORMAL, VELOCITY) * (1.0 + collision_bounce);
			VELOCITY = mix(VELOCITY,vec3(0.0),clamp(collision_friction, 0.0, 1.0));
		} else {
			VELOCITY = vec3(0.0);
		}
	}
	float scale = texture(scale_curve, vec2(CUSTOM.y, 0.0)).x * remap(CUSTOM.x, 0.0, 1.0, min_scale, max_scale);
	TRANSFORM *= mat4(rotateZ(abs(length(VELOCITY)) * 0.1));

	TRANSFORM[0].xyz = normalize(TRANSFORM[0].xyz);
	TRANSFORM[1].xyz = normalize(TRANSFORM[1].xyz);
	TRANSFORM[2].xyz = normalize(TRANSFORM[2].xyz);
	
	TRANSFORM[0].xyz *= scale;
	TRANSFORM[1].xyz *= scale;
	TRANSFORM[2].xyz *= scale;
}
