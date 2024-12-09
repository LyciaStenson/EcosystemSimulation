extends CharacterBody3D
class_name UtilityAgent

@onready var nav_agent : NavigationAgent3D = $NavigationAgent

#@onready var sensor : UtilitySensor = $UtilitySensor

var birth_time : float

var world_context : UtilityWorldContext = UtilityWorldContext.new()

@export var motives : Array[UtilityMotive]

@export var actions : Array[UtilityAction]

func _ready():
	birth_time = Time.get_ticks_msec()

func _process(_delta):
	get_discontentment(world_context)

func get_discontentment(context : UtilityWorldContext) -> float:
	var discontentment : float = 0.0
	for motive in motives:
		discontentment += motive.get_insistence(context)
	return discontentment
