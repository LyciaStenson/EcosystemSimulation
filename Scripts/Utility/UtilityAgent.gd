extends CharacterBody3D
class_name UtilityAgent

@onready var nav_agent : NavigationAgent3D = $NavigationAgent

var birth_time : float

var world_context : UtilityWorldContext = UtilityWorldContext.new()

@export var actions : Array[UtilityAction]

func _ready():
	birth_time = Time.get_ticks_msec()

func _process(_delta):
	var best_action : UtilityAction = get_best_action(world_context)
	print("Best Action: ", best_action.name)

func get_best_action(context : UtilityWorldContext) -> UtilityAction:
	var best_action : UtilityAction
	var best_insistence : float = -1.0
	for action in actions:
		var insistence : float = action.get_insistence(context)
		if insistence > best_insistence:
			best_insistence = insistence
			best_action = action
	return best_action

func get_discontentment(context : UtilityWorldContext) -> float:
	var discontentment : float = 0.0
	for action in actions:
		discontentment += action.get_insistence(context)
	return discontentment
