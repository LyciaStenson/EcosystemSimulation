extends Behavior

var predators : Array[Node3D]

func _ready():
	get_parent().add_to_group("Prey")

func _process(_delta):
	if !predators.is_empty():
		var predator_dir : Vector3 = (agent.global_position - predators[0].global_position).normalized()
		target_position = agent.global_position + predator_dir

func visibility_entered(body : Node3D):
	if body.is_in_group("Predator"):
		predators.append(body)

func visibility_exited(body : Node3D):
	if predators.has(body):
		predators.erase(body)
