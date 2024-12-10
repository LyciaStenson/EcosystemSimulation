extends Area3D
class_name UtilitySensor

@export var target_group : String

var targets : Array[Node3D]

func _ready():
	connect("body_entered", body_entered)
	connect("body_exited", body_exited)

func body_entered(body : Node3D):
	if body.is_in_group(target_group):
		targets.append(body)

func body_exited(body : Node3D):
	if targets.has(body):
		targets.erase(body)
