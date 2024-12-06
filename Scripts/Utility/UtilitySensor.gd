extends Area3D
class_name UtilitySensor

var targetGroups : Array[String]

var targets : Array[Node3D]

func visibility_entered(body : Node3D):
	for group in targetGroups:
		if body.is_in_group("Predator"):
			targets.append(group)

func visibility_exited(body : Node3D):
	if targets.has(body):
		targets.erase(body)
