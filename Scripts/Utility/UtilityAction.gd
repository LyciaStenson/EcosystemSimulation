extends Resource
class_name UtilityAction

@export var name : String

@export var considerations : Array[UtilityConsideration]

func get_insistence(context : UtilityWorldContext) -> float:
	var result : float = 1.0
	for consideration in considerations:
		#var old_result : float = result
		result *= consideration.evaluate(context)
	return result

func get_duplicate() -> UtilityAction:
	var new_duplicate : UtilityAction = self.duplicate(true)
	var duplicated_considerations : Array[UtilityConsideration] = []
	for consideration in considerations:
		duplicated_considerations.append(consideration.duplicate(true))
	new_duplicate.considerations = duplicated_considerations
	return new_duplicate
