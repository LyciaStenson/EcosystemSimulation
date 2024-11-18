extends Node3D
class_name Predator

var velocity : Vector3

const SPEED = 3.0

@onready var nav_agent : NavigationAgent3D = $NavigationAgent

@export var prey : Node3D

var birth_time : float

func _ready():
	birth_time = Time.get_ticks_msec()
	
	set_physics_process(false)
	call_deferred("nav_server_ready")

func nav_server_ready():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	nav_agent.target_position = get_target_position()
	
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	
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
	
	global_position += velocity * delta
	
	#move_and_slide()

func get_target_position() -> Vector3:
	if prey:
		return prey.global_position
	else:
		return Vector3()

func get_age() -> float:
	return (Time.get_ticks_msec() - birth_time) * 0.001
