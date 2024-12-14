extends BiasableConsideration
class_name CurveConsideration

@export var curve : Curve

@export var value_multiplier : float = 1.0

@export var context_key : String

func evaluate(context : UtilityWorldContext) -> float:
	return curve.sample(context.data[context_key] * value_multiplier) * bias
