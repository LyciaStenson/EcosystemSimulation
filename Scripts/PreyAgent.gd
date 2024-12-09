extends UtilityAgent
class_name PreyAgent

var hydration : float = 1.0
var dehydration_rate : float = 0.1

@onready var hydration_bar : MeshInstance3D = $HydrationBar
@onready var hydration_bar_shader := hydration_bar.get_active_material(0) as ShaderMaterial

func _ready():
	var hydration_motive := UtilityMotive.new()
	hydration_motive.considerations
	motives = [
		
	]
	world_context.data = {
		"hydration": false
	}

func _process(delta):
	hydration -= dehydration_rate * delta
	if hydration <= 0.0:
		queue_free()
	hydration = clampf(hydration, 0.0, 1.0)
	hydration_bar_shader.set_shader_parameter("value", normalize_to_bar(hydration))
	world_context.data["hydration"] = hydration

func normalize_to_bar(value : float) -> float:
	return (value - 0.5) * 0.8

func wander():
	print("Wander")

func flee():
	print("Flee")
