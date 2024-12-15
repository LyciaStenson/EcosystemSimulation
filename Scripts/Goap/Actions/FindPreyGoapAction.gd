extends GoapAction
#class_name FindPreyGoapAction

#func get_preconditions() -> Dictionary:
	#return {
		#"has_food": false,
		#"prey_in_sight": false
	#}

#func get_effects() -> Dictionary:
	#return {
		#"has_food": true
	#}

#func perform() -> void:
	#print("FindPreyGoapAction")
