extends UtilityConsideration
class_name BooleanConsideration

enum UsefulWhen {
	TRUE = 1,
	FALSE = 0,
}

@export var context_key : String

# Export as enum so it appears in editor as a dropdown selection
@export var useful_when : UsefulWhen = UsefulWhen.TRUE

func evaluate(context : UtilityWorldContext) -> float:
	return context.data[context_key] == bool(useful_when)
