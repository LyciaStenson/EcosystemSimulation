extends Behavior

var predators : Array[Node3D]

@onready var energy_bar : MeshInstance3D = $"../EnergyBar"

#@export var danger_curve : Curve

func _ready():
	agent.add_to_group("Prey")

func _process(_delta):
	if !predators.is_empty():
		var predator_dir : Vector3 = (agent.global_position - predators[0].global_position).normalized()
		agent.nav_agent.target_position = agent.global_position + predator_dir * 100

func visibility_entered(body : Node3D):
	if body.is_in_group("Predator"):
		predators.append(body)

func visibility_exited(body : Node3D):
	if predators.has(body):
		predators.erase(body)
	#if predators.is_empty():
		#agent.nav_agent.target_position = Vector3()
