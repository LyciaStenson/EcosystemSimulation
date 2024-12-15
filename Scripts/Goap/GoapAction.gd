extends Resource
class_name GoapAction

@export var preconditions : Array[GoapStateCondition]
@export var effects : Array[GoapStateCondition]

func get_cost() -> float:
	return 0.0

func perform() -> void:
	pass
