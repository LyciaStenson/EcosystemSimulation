extends MeshInstance3D
class_name Bar

@onready var shader := get_active_material(0) as ShaderMaterial

func set_value(value : float):
	shader.set_shader_parameter("value", normalize_to_bar(value))

func set_parent_scale(value : float):
	shader.set_shader_parameter("parent_scale", value)

func normalize_to_bar(value : float) -> float:
	return (value - 0.5) * 0.8
