extends UtilityConsideration
class_name CurveConsideration

@export var curve : Curve

@export var context_key : String

func evaluate(context : UtilityWorldContext) -> float:
	return curve.sample(context.data[context_key])
