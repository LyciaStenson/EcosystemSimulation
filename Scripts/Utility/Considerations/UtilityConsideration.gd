extends Resource
class_name UtilityConsideration

# Override this function with equation accounting for context data
func evaluate(_context : UtilityWorldContext) -> float:
	return 0.9

func get_duplicate() -> UtilityConsideration:
	return self.duplicate(true)
