extends UtilityAgent
class_name PreyAgent

var age_proportion : float = 0.0 # age as a proportion of lifetime

var hydration : float = 1.0
var dehydration_rate : float = 0.02

var drinking : bool = false
var drink_rate : float = 0.02

@onready var lifetime_bar : Bar = $LifetimeBar
@onready var hydration_bar : Bar = $HydrationBar

@onready var water_sensor : UtilitySensor = $WaterSensor

@export_range(1.0, 10000.0, 1.0) var lifetime : float = 1.0

func _ready():
	super()
	
	world_context.data = {
		"age": 0.0,
		"hydration": hydration,
		"water_in_sight": false
	}

func _physics_process(delta):
	best_action = get_best_action(world_context)
	if drinking:
		hydration += drink_rate * delta
		drinking = false
		print("NOT DRINKING")
	else:
		hydration -= dehydration_rate * delta
	age_proportion = ((Time.get_ticks_msec() - birth_time) * 0.001) / lifetime
	if hydration <= 0.0 || age_proportion >= 1.0:
		queue_free()
	hydration = clampf(hydration, 0.0, 1.0)
	hydration_bar.set_value(hydration)
	world_context.data["hydration"] = hydration
	world_context.data["age"] = age_proportion
	lifetime_bar.set_value(age_proportion)
	world_context.data["water_in_sight"] = !water_sensor.targets.is_empty()
	
	call(best_action.name)
	
	super(delta)

func wander():
	#print("Wander")
	nav_agent.target_position = Vector3(0.0, 0.0, 0.0)

func flee():
	print("Flee")

func find_water():
	pass
	#print("Find Water")
	#nav_agent.target_position = Vector3(100.0, 0.0, 100.0)

func go_to_water():
	nav_agent.target_position = water_sensor.get_nearest().global_position
	if nav_agent.is_navigation_finished():
		drinking = true
		print("DRINKING")
