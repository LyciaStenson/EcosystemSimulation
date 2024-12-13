extends BiasableConsideration
class_name ConstantConsideration

@export_range(0.0, 1.0, 0.001) var utility : float = 0.0

func evaluate(_context: UtilityWorldContext) -> float:
	return utility * bias
