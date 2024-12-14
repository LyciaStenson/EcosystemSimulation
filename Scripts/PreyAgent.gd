extends UtilityAgent
class_name PreyAgent

var age_proportion : float = 0.0 # age as a proportion of lifetime

var wander_direction : Vector3
var wander_timer : float = 15.0
@export var wander_time : float = 15.0

var hydration : float = 1.0
var dehydration_rate : float = 0.02

var known_waters : Array[Vector3]
var nearest_known_water : Vector3
var checked_waters : bool = false

var at_water : bool = false
var drink_rate : float = 0.05

var wants_to_mate : bool = false
var with_mate : bool = false
var last_mate_time : float = 0.0
var offspring_num : int = 0

@onready var ecosystem_manager : EcosystemManager = get_parent()

@onready var lifetime_bar : Bar = $LifetimeBar
@onready var hydration_bar : Bar = $HydrationBar
@onready var current_action_label : Label3D = $CurrentActionLabel

@onready var water_sensor : UtilitySensor = $WaterSensor
@onready var prey_sensor : UtilitySensor = $PreySensor
@onready var predator_sensor : UtilitySensor = $PredatorSensor

@export_range(1.0, 10000.0, 1.0) var lifetime : float = 1.0

func _ready():
	super()
	
	world_context.data = {
		"hydration": hydration,
		"water_known": false,
		"at_water": false,
		"predator_in_sight": false,
		"predator_dist_sqrd": 0.0,
		"age": 0.0,
		"offspring_num": 0,
		"mate_in_sight": false,
		"with_mate": false,
		"time_since_mating": 0.0
	}
	
	water_sensor.target_entered.connect(water_found)

func water_found(water : Node3D):
	known_waters.append(water.global_position)

func _physics_process(delta : float):
	var age_scale : float = clampf(age_proportion * 5.0, 0.65, 1.0)
	scale = Vector3(1.0, 1.0, 1.0) * age_scale
	if !at_water:
		hydration -= dehydration_rate * delta
	var scaled_time : float = Time.get_ticks_msec() * Engine.time_scale
	age_proportion = ((scaled_time - birth_time) * 0.001) / lifetime
	if hydration <= 0.0 || age_proportion >= 1.0:
		ecosystem_manager.prey_death()
		queue_free()
	hydration = clampf(hydration, 0.0, 1.0)
	hydration_bar.set_value(hydration)
	hydration_bar.set_parent_scale(age_scale)
	lifetime_bar.set_value(age_proportion)
	lifetime_bar.set_parent_scale(age_scale)
	
	if !predator_sensor.targets.is_empty():
		world_context.data["predator_dist_sqrd"] = global_position.distance_squared_to(predator_sensor.get_nearest().global_position)
	
	world_context.data["hydration"] = hydration
	world_context.data["water_known"] = !known_waters.is_empty()
	world_context.data["at_water"] = at_water
	world_context.data["predator_in_sight"] = !predator_sensor.targets.is_empty()
	world_context.data["age"] = age_proportion
	world_context.data["offspring_num"] = offspring_num
	world_context.data["mate_in_sight"] = get_mate_in_sight()
	world_context.data["with_mate"] = with_mate
	world_context.data["time_since_mating"] = (scaled_time - last_mate_time) * 0.001
	
	best_action = get_best_action(world_context)
	
	if previous_action && best_action != previous_action && has_method(previous_action.name + "_end"):
		call(previous_action.name + "_end")
	
	if has_method(best_action.name):
		call(best_action.name, delta)
		current_action_label.text = best_action.name
	#print(best_action.name)
	
	previous_action = best_action
	
	super(delta)

# Genetic mutations are simulated by applying a multiplication ranging from 0.85 to 1.15 to the bias of each consideration
func mutate():
	for action in actions:
		for consideration in action.considerations:
			if consideration is BiasableConsideration:
				var bias_multiplier : float = randf_range(0.85, 1.15)
				consideration.bias *= bias_multiplier

func wander(delta : float):
	wander_timer += delta
	if wander_timer > wander_time || nav_agent.is_navigation_finished():
		wander_timer = 0.0
		nav_agent.target_position = Vector3(randf_range(-24.0, 24.0), 0.0, randf_range(-24.0, 24.0))

func flee(_delta : float):
	print("FLEE")
	var nearest_predator : Node3D = predator_sensor.get_nearest()
	var predator_direction : Vector3 = global_position.direction_to(nearest_predator.global_position)
	nav_agent.target_position = global_position - predator_direction * 100.0

func find_water(delta : float):
	wander(delta)

func find_mate(delta : float):
	wants_to_mate = true
	wander(delta)

func find_mate_end():
	wants_to_mate = false

func go_to_mate(delta : float):
	wants_to_mate = true
	var nearest_mate_pos : Vector3 = get_nearest_mate()
	if nav_agent.target_position != nearest_mate_pos:
		nav_agent.target_position = nearest_mate_pos
	if nav_agent.is_navigation_finished():
		with_mate = true

func go_to_mate_end():
	wants_to_mate = false

func mate(delta : float):
	wants_to_mate = true
	last_mate_time = Time.get_ticks_msec() * Engine.time_scale
	offspring_num += 1
	ecosystem_manager.spawn_prey(global_position)

func mate_end():
	wants_to_mate = false
	with_mate = false

func go_to_water(_delta : float):
	var new_water_pos : Vector3 = get_nearest_known_water_pos()
	if nav_agent.target_position != new_water_pos:
		nav_agent.target_position = new_water_pos
	if nav_agent.is_navigation_finished() || global_position.distance_squared_to(new_water_pos) < 8.0:
		at_water = true

func go_to_water_end():
	checked_waters = false

func drink(delta : float):
	hydration += drink_rate * delta

func drink_end():
	at_water = false

func get_mate_in_sight() -> bool:
	for prey in prey_sensor.targets:
		if prey.wants_to_mate:
			return true
	return false

func get_nearest_mate() -> Vector3:
	var nearest_dist_sqrd : float = INF
	var nearest_mate_pos : Vector3
	for prey in prey_sensor.targets:
		if prey.wants_to_mate:
			var new_dist_sqrd : float = global_position.distance_squared_to(prey.global_position)
			if new_dist_sqrd < nearest_dist_sqrd:
				nearest_dist_sqrd = new_dist_sqrd
				nearest_mate_pos = prey.global_position
	return nearest_mate_pos

func get_nearest_known_water_pos() -> Vector3:
	if checked_waters:
		return nearest_known_water
	checked_waters = true
	if known_waters.is_empty():
		push_error("Trying to get nearest water when know waters known")
		return Vector3()
	var new_nearest_known_water : Vector3 = known_waters[0]
	var nearest_dist_sqrd : float = global_position.distance_squared_to(known_waters[0])
	for i in range(1, known_waters.size()):
		var new_dist_sqrd = global_position.distance_squared_to(known_waters[i])
		if new_dist_sqrd < nearest_dist_sqrd:
			nearest_dist_sqrd = new_dist_sqrd
			new_nearest_known_water = known_waters[i]
	nearest_known_water = new_nearest_known_water
	return nearest_known_water
