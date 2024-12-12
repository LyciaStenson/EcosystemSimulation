extends CharacterBody3D
class_name UtilityAgent

@onready var nav_agent : NavigationAgent3D = $NavigationAgent

var birth_time : float

var world_context : UtilityWorldContext = UtilityWorldContext.new()

@export var actions : Array[UtilityAction]
var best_action : UtilityAction
var previous_action : UtilityAction

@export var speed : float = 1.0

var direction : Vector3

func _ready():
	birth_time = Time.get_ticks_msec()
	
	set_physics_process(false)
	call_deferred("enable_physics_process")

func enable_physics_process():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		direction = Vector3()
	
	direction = global_position.direction_to(nav_agent.get_next_path_position())
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

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
