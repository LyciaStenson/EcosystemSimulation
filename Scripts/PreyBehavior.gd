extends Behavior

var predators : Array[Node3D]

@onready var hydration_bar : MeshInstance3D = $"../HydrationBar"

#@export var danger_curve : Curve

var wander_target_timer : float
var wander_target_time : float

var wander_target : Vector3

var hydration : float = 1.0
var dehydration_rate : float = 0.05
@onready var hydration_bar_shader := hydration_bar.get_active_material(0) as ShaderMaterial

enum Action { WANDER, FIND_WATER, FLEE }

var current_action : Action

func _ready():
	agent.add_to_group("Prey")
	
	wander_target_time = randf_range(4.5, 5.5)
	wander_target_timer = wander_target_time # Initialise time to timer so wander dir runs the first time

func _process(delta : float):
	current_action = determine_action()
	perform_action(delta)
	
	hydration -= dehydration_rate * delta
	if hydration <= 0.0:
		agent.queue_free()
	hydration = clampf(hydration, 0.0, 1.0)
	hydration_bar_shader.set_shader_parameter("value", normalize_to_bar(hydration))

func visibility_entered(body : Node3D):
	if body.is_in_group("Predator"):
		predators.append(body)

func visibility_exited(body : Node3D):
	if predators.has(body):
		predators.erase(body)

func determine_action() -> Action:
	if !predators.is_empty():
		return Action.FLEE
	else:
		return Action.WANDER

func perform_action(delta : float):
	match current_action:
		Action.WANDER:
			wander_target_timer += delta
			if wander_target_timer >= wander_target_time:
				wander_target = Vector3(randf_range(24.0, -24.0), 0.0, randf_range(24.0, -24.0))
				agent.nav_agent.target_position = wander_target
				wander_target_timer = 0.0
		Action.FIND_WATER:
			print("FIND_WATER")
		Action.FLEE:
			var predator_dir : Vector3 = (agent.global_position - predators[0].global_position).normalized()
			agent.nav_agent.target_position = agent.global_position + predator_dir * 100

func normalize_to_bar(value : float) -> float:
	return (value - 0.5) * 0.8
