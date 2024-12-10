extends UtilityConsideration
class_name ConstantConsideration

@export_range(0.0, 1.0, 0.01) var utility : float = 0.0

func evaluate(context: UtilityWorldContext) -> float:
	return utility
