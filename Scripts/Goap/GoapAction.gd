extends Resource
class_name GoapAction

var agent : GoapAgent

# Override with preconditions and effects dictionaries for specific goal
# Dictionary with String key and bool value

# Preconditions are required to perform action
func get_preconditions() -> Dictionary:
	return {}

# Effects are outcomes after acion is performed
func get_effects() -> Dictionary:
	return {}

func get_cost() -> float:
	return 0.0

func perform() -> void:
	pass
