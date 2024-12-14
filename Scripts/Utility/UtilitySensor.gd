extends Area3D
class_name UtilitySensor

@export var target_group : String

@export var ignore_parent : bool

@onready var parent : Node3D = get_parent()

var targets : Array[Node3D]

signal target_entered(body : Node3D)
signal target_exited(body : Node3D)

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

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

func on_body_entered(body : Node3D):
	if body != parent && body.is_in_group(target_group):
		target_entered.emit(body)
		targets.append(body)

func on_body_exited(body : Node3D):
	if body != parent && targets.has(body):
		target_exited.emit(body)
		targets.erase(body)
