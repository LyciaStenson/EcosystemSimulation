extends CharacterBody3D
class_name UtilityAgent

@onready var nav_agent : NavigationAgent3D = $NavigationAgent

var birth_time : float

var world_context : UtilityWorldContext = UtilityWorldContext.new()

@export var motives : Array[UtilityMotive]

@export var actions : Array[UtilityAction]

func _ready():
	birth_time = Time.get_ticks_msec()

func _process(_delta):
	var best_motive : UtilityMotive = get_best_motive(world_context)
	print("Best Motive: ", best_motive.name)

func get_best_motive(context : UtilityWorldContext) -> UtilityMotive:
	var best_motive : UtilityMotive
	var best_insistence : float = -1.0
	for motive in motives:
		var insistence : float = motive.get_insistence(context)
		if insistence > best_insistence:
			best_insistence = insistence
			best_motive = motive
	return best_motive

func get_discontentment(context : UtilityWorldContext) -> float:
	var discontentment : float = 0.0
	for motive in motives:
		discontentment += motive.get_insistence(context)
	return discontentment
