extends Behavior

var targets : Array[Node3D]

func _ready():
	agent.add_to_group("Predator")

func _process(_delta):
	if !targets.is_empty():
		var closest_dist_sqrd : float = INF
		var closest_dist_pos : Vector3 = Vector3.ZERO
		for target in targets:
			var target_dist_sqrd : float = agent.global_position.distance_squared_to(target.global_position)
			if target_dist_sqrd < closest_dist_sqrd:
				closest_dist_sqrd = target_dist_sqrd
				closest_dist_pos = target.global_position
		agent.nav_agent.target_position = closest_dist_pos

func visibility_entered(body : Node3D):
	if body.is_in_group("Prey"):
		targets.append(body)

func visibility_exited(body : Node3D):
	if targets.has(body):
		targets.erase(body)
		#if targets.is_empty():
			#agent.nav_agent.target_position = Vector3()

func attack_entered(body : Node3D):
	if body.is_in_group("Prey"):
		body.queue_free()
