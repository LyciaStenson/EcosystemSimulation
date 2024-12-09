extends Resource
class_name UtilityMotive

@export var considerations : Array[UtilityConsideration]

func get_insistence(context : UtilityWorldContext) -> float:
	var result : float = 1.0
	for consideration in considerations:
		result *= consideration.get_utility(context)
	return result
