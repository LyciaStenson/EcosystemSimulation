extends AvoidConsideration
class_name HydrationConsideration

# The key for the relevant data in the world context dictionary
var context_key : String = "hydration"

func get_utility(context : UtilityWorldContext) -> float:
	print(context.data[context_key])
	return context.data[context_key]
