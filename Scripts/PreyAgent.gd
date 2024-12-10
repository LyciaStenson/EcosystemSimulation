extends UtilityAgent
class_name PreyAgent

var age_proportion : float = 0.0

var hydration : float = 1.0
var dehydration_rate : float = 0.05

@onready var hydration_bar : MeshInstance3D = $HydrationBar
@onready var hydration_bar_shader := hydration_bar.get_active_material(0) as ShaderMaterial

@onready var water_sensor : UtilitySensor = $WaterSensor

@export_range(1.0, 10000.0, 1.0) var lifetime : float = 1.0

func _ready():
	super()
	world_context.data = {
		"age": 0.0,
		"hydration": hydration,
		"water_in_sight": false
	}

func _process(delta):
	hydration -= dehydration_rate * delta
	if hydration <= 0.0:
		queue_free()
	hydration = clampf(hydration, 0.0, 1.0)
	hydration_bar_shader.set_shader_parameter("value", normalize_to_bar(hydration))
	world_context.data["hydration"] = hydration
	age_proportion = ((Time.get_ticks_msec() - birth_time) * 0.001) / lifetime
	world_context.data["age"] = age_proportion
	world_context.data["water_in_sight"] = !water_sensor.targets.is_empty()
	super(delta)

func normalize_to_bar(value : float) -> float:
	return (value - 0.5) * 0.8

func wander():
	print("Wander")

func flee():
	print("Flee")

func drink():
	hydration = 1.0
	print("Drink")
