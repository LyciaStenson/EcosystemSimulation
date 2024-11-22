extends Behavior

var targets : Array[Node3D]

func _process(delta):
	if !targets.is_empty():
		target_position = targets[0].global_position

func visibility_entered(body : Node3D):
	if body is Prey:
		targets.append(body)

func visibility_exited(body : Node3D):
	if targets.has(body):
		targets.erase(body)
