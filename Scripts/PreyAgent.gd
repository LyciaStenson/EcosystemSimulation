extends UtilityAgent
class_name PreyAgent

var age_proportion : float = 0.0 # age as a proportion of lifetime

var hydration : float = 1.0
var dehydration_rate : float = 0.02

var at_water : bool = false
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
		"water_in_sight": false,
		"at_water": false
	}

func _physics_process(delta):
	if !at_water:
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
	world_context.data["at_water"] = at_water
	
	best_action = get_best_action(world_context)
	if previous_action && best_action != previous_action && has_method(previous_action.name + "_end"):
		call(previous_action.name + "_end")
	
	call(best_action.name, delta)
	print(best_action.name)
	
	previous_action = best_action
	
	super(delta)

func wander(delta : float):
	nav_agent.target_position = Vector3(0.0, 0.0, 0.0)

func flee(delta : float):
	pass

func find_water(delta : float):
	pass

func go_to_water(delta : float):
	nav_agent.target_position = water_sensor.get_nearest().global_position
	if nav_agent.is_navigation_finished():
		at_water = true

func drink(delta : float):
	hydration += drink_rate * delta

func drink_end():
	at_water = false
