extends CharacterBody3D
class_name Prey

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

const SPEED : float = 3.0

var lifetime : float = 120.0

var birth_time : float

@onready var nav_agent : NavigationAgent3D = $NavigationAgent
@onready var visibility_area : Area3D = $VisibilityArea

@export var prey : Node3D

#var velocity : Vector3

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
	
	nav_agent.target_position = get_target_position()
	
	var direction : Vector3
	
	if nav_agent.is_navigation_finished():
		direction = Vector3()
	
	direction = global_position.direction_to(nav_agent.get_next_path_position())
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#global_position += velocity * delta
	move_and_slide()

func get_target_position() -> Vector3:
	if prey:
		return prey.global_position
	else:
		return Vector3()

func get_age() -> float:
	return (Time.get_ticks_msec() - birth_time) * 0.001
