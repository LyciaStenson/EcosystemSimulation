extends CharacterBody3D
class_name Agent

@export var speed : float = 3.0

var lifetime : float = 180.0

@onready var nav_agent : NavigationAgent3D = $NavigationAgent
@onready var visibility_area : Area3D = $VisibilityArea

@onready var behavior : Behavior = $Behavior

var birth_time : float

func _ready():
	birth_time = Time.get_ticks_msec()
	
	set_physics_process(false)
	call_deferred("nav_server_ready")

func nav_server_ready():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	if get_age() > lifetime:
		queue_free()
	
	nav_agent.target_position = behavior.target_position
	
	var direction : Vector3
	
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

func get_age() -> float:
	return (Time.get_ticks_msec() - birth_time) * 0.001
