extends CharacterBody3D
class_name UtilityAgent

@onready var nav_agent : NavigationAgent3D = $NavigationAgent

#@onready var sensor : UtilitySensor = $UtilitySensor

var birth_time : float

var world_context : UtilityWorldContext

var actions : Array[UtilityAction]

func _ready():
	birth_time = Time.get_ticks_msec()

func _process(delta):
	pass
