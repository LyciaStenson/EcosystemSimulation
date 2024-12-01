shader_type spatial;
render_mode cull_disabled;

uniform float value;

varying vec3 pos;

void vertex() {
	pos = mat3(MODEL_MATRIX) * VERTEX;
}

void fragment() {
	if (pos.x > value) {
		discard;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
