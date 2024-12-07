extends NavigationRegion3D

@export_category("Predator")
@export var predator_num : int
@export_group("Scene")
@export var predator_scene : PackedScene

@export_category("Prey")
@export var prey_num : int
@export_group("Scene")
@export var prey_scene : PackedScene

@export_category("Environment")
@export var noise_threshold : float
@export var water_num : int
@export var tree_num : int

@export_group("Scenes and Meshes")
@export var water_scene : PackedScene
@export var tree_mesh : Mesh
@export var leaves_mesh : Mesh

@onready var fast_noise : FastNoiseLite = FastNoiseLite.new()

var tree_multimesh : MultiMeshInstance3D
var leaves_multimesh : MultiMeshInstance3D

var high_positions : Array[Vector3] = []
var low_positions : Array[Vector3] = []

func _ready():
	fast_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise.seed = randi()
	generate_spawn_positions()
	generate_water()
	generate_trees()
	generate_nav()

func generate_nav():
	var source_geometry_data : NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()
	
	NavigationServer3D.parse_source_geometry_data(navigation_mesh, source_geometry_data, self)
	NavigationServer3D.bake_from_source_geometry_data(navigation_mesh, source_geometry_data, spawn_agents)

func spawn_agents():
	for i in predator_num:
		var instantiated_scene := predator_scene.instantiate()
		var position_index : int = randi_range(0, low_positions.size() - 1)
		instantiated_scene.position = low_positions[position_index]
		low_positions.remove_at(position_index)
		add_child(instantiated_scene)
	
	for i in prey_num:
		var instantiated_scene := prey_scene.instantiate()
		var position_index : int = randi_range(0, low_positions.size() - 1)
		instantiated_scene.position = low_positions[position_index]
		low_positions.remove_at(position_index)
		add_child(instantiated_scene)

func generate_spawn_positions():
	for x in range(-240, 240):
		for y in range(-240, 240):
			var noise : float = fast_noise.get_noise_2d(x, y)
			if noise > noise_threshold:
				high_positions.append(Vector3(x / 10.0, 0.0, y / 10.0))
			elif noise < noise_threshold - 0.1: # -0.1 creates a border where agents won't spawn too close to trees
				low_positions.append(Vector3(x / 10.0, 0.0, y / 10.0))
	if low_positions.is_empty():
		push_error("Noise Threshold too low")

func generate_water():
	for i in water_num:
		var instantiated_scene : StaticBody3D = water_scene.instantiate()
		var position_index : int = randi_range(0, low_positions.size() - 1)
		add_child(instantiated_scene)
		instantiated_scene.global_position = low_positions[position_index]
		low_positions.remove_at(position_index)
		var new_low_positions : Array[Vector3] = []
		for pos in low_positions:
			var dist_sqrd : float = (pos - instantiated_scene.global_position).length_squared()
			if dist_sqrd > 4.0:
				new_low_positions.append(pos)
		low_positions = new_low_positions

func generate_trees():
	leaves_multimesh = MultiMeshInstance3D.new()
	leaves_multimesh.multimesh = MultiMesh.new()
	leaves_multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	leaves_multimesh.multimesh.mesh = leaves_mesh
	tree_multimesh = MultiMeshInstance3D.new()
	tree_multimesh.multimesh = MultiMesh.new()
	tree_multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	tree_multimesh.multimesh.mesh = tree_mesh
	
	tree_multimesh.multimesh.instance_count = tree_num
	leaves_multimesh.multimesh.instance_count = tree_num
	
	for i in tree_num:
		var position_index : int = randi_range(0, high_positions.size() - 1)
		add_tree(i, high_positions[position_index])
	
	add_child(tree_multimesh)
	add_child(leaves_multimesh)

func add_tree(index : int, tree_pos : Vector3):
	tree_multimesh.multimesh.set_instance_transform(index, Transform3D(Basis(), tree_pos + Vector3.UP))
	leaves_multimesh.multimesh.set_instance_transform(index, Transform3D(Basis(), tree_pos + Vector3.UP * 2))
