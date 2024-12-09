extends Resource
class_name UtilityConsideration

@export var context_key : String

@export var curve : Curve

# Override this function with equation accounting for context data
func get_utility(context : UtilityWorldContext) -> float:
	print(curve.sample(context.data[context_key]))
	return curve.sample(context.data[context_key])
