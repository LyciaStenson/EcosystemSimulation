extends Area3D
class_name UtilitySensor

@export var target_group : String

var targets : Array[Node3D]

func _ready():
	connect("body_entered", body_entered)
	connect("body_exited", body_exited)

func get_nearest() -> Node3D:
	if targets.is_empty():
		return null
	var nearest_target : Node3D = targets[0]
	var nearest_dist_sqrd : float = global_position.distance_squared_to(targets[0].global_position)
	for i in range(1, targets.size()):
		var new_dist_sqrd = global_position.distance_squared_to(targets[i].global_position)
		if new_dist_sqrd < nearest_dist_sqrd:
			nearest_dist_sqrd = new_dist_sqrd
			nearest_target = targets[i]
	return nearest_target

func body_entered(body : Node3D):
	if body.is_in_group(target_group):
		targets.append(body)

func body_exited(body : Node3D):
	if targets.has(body):
		targets.erase(body)
