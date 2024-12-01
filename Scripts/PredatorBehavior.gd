extends Behavior

var targets : Array[Node3D]

func _ready():
	get_parent().add_to_group("Predator")

func _process(_delta):
	if !targets.is_empty():
		target_position = targets[0].global_position

func visibility_entered(body : Node3D):
	if body.is_in_group("Prey"):
		targets.append(body)

func visibility_exited(body : Node3D):
	if targets.has(body):
		targets.erase(body)
		if targets.is_empty():
			target_position = Vector3()

func attack_entered(body : Node3D):
	if body.is_in_group("Prey"):
		body.queue_free()
