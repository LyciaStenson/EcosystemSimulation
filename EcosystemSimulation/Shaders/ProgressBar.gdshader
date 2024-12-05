shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;

uniform float value;

varying vec3 pos;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	pos = mat3(MODEL_MATRIX) * VERTEX;
}

void fragment() {
	if (pos.x > value) {
		discard;
	}
}
