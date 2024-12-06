extends UtilityMotive
class_name CurveUtilityMotive

@export var curve : Curve

@export var contextKey : String

func get_insistence(context : UtilityWorldContext) -> float:
	return curve.sample(context.data[contextKey])
