shader_type spatial;
render_mode cull_disabled;
render_mode unshaded;

uniform vec3 color : source_color;

uniform float value;

varying vec3 pos;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	pos = mat3(MODEL_MATRIX) * VERTEX;
}

void fragment() {
	bool isEdge = (pos.x < -0.39) || (pos.x > 0.39) || (pos.y > 0.04) || (pos.y < -0.04);
	if (!isEdge && (pos.x > value)) {
		discard;
	}
	ALBEDO = color;
}
