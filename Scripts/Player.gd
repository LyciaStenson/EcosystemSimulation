extends Node3D

@export var speed : float = 7.0

@onready var camera = $Camera

var velocity : Vector3

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	var horizontal_dir : Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	
	var vertical_dir : float = 0.0
	
	if (Input.is_action_just_pressed("IncreaseTimeScale")):
		var new_time_scale : float = Engine.time_scale
		new_time_scale += 1.0
		new_time_scale = clampf(new_time_scale, 1.0, 35.0)
		Engine.time_scale = new_time_scale
	if (Input.is_action_just_pressed("DecreaseTimeScale")):
		var new_time_scale : float = Engine.time_scale
		new_time_scale -= 1.0
		new_time_scale = clampf(new_time_scale, 1.0, 35.0)
		Engine.time_scale = new_time_scale
	if (Input.is_action_pressed("MoveUp")):
		vertical_dir += 1.0
	if (Input.is_action_pressed("MoveDown")):
		vertical_dir -= 1.0
	
	var direction : Vector3 = (global_basis * Vector3(horizontal_dir.x, 0.0, horizontal_dir.y)).normalized()
	direction.y = vertical_dir
	
	var scaled_delta : float = delta
	if Engine.time_scale != 0.0:
		scaled_delta /= Engine.time_scale
	
	if direction:
		velocity = direction * speed
	else:
		velocity.x = lerpf(velocity.x, 0.0, 15.0 * scaled_delta)
		velocity.y = lerpf(velocity.y, 0.0, 15.0 * scaled_delta)
		velocity.z = lerpf(velocity.z, 0.0, 15.0 * scaled_delta)
	
	global_position += velocity * scaled_delta

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		
		camera.rotation_degrees.x = clampf(camera.rotation_degrees.x, -90.0, 90.0)
