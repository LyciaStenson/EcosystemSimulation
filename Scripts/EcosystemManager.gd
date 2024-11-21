extends NavigationRegion3D

@export var predator_num : int
@export var prey_num : int
@export var tree_threshold : float
@export_range(0, 1, 0.001) var tree_probability : float

@export var predator_scene : PackedScene
@export var prey_scene : PackedScene
@export var tree_mesh : Mesh
@export var leaves_mesh : Mesh

@onready var fast_noise : FastNoiseLite = FastNoiseLite.new()

var tree_multimesh : MultiMeshInstance3D
var leaves_multimesh : MultiMeshInstance3D

var tree_positions : Array[Vector3]

var spawn_positions : Array[Vector3]

func _ready():
	generate_noise()
	generate_trees()
	generate_nav()

func generate_nav():
	var source_geometry_data : NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()
	
	NavigationServer3D.parse_source_geometry_data(navigation_mesh, source_geometry_data, self)
	NavigationServer3D.bake_from_source_geometry_data(navigation_mesh, source_geometry_data, bake_nav_done)

func bake_nav_done():
	for i in predator_num:
		var instantiated_scene : Predator = predator_scene.instantiate()
		var spawn_position_index : int = randi_range(0, spawn_positions.size() - 1)
		instantiated_scene.position = spawn_positions[spawn_position_index]
		spawn_positions.remove_at(spawn_position_index)
		add_child(instantiated_scene)
	
	for i in prey_num:
		var instantiated_scene : Prey = prey_scene.instantiate()
		var spawn_position_index : int = randi_range(0, spawn_positions.size() - 1)
		instantiated_scene.position = spawn_positions[spawn_position_index]
		spawn_positions.remove_at(spawn_position_index)
		add_child(instantiated_scene)

func generate_noise():
	fast_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise.seed = randi()
	
	for x in range(-240, 240):
		for y in range(-240, 240):
			if fast_noise.get_noise_2d(x, y) < tree_threshold:
				print(x, ", ", y)
				spawn_positions.append(Vector3(x / 10.0, 0.0, y / 10.0))

func generate_trees():
	leaves_multimesh = MultiMeshInstance3D.new()
	leaves_multimesh.multimesh = MultiMesh.new()
	leaves_multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	leaves_multimesh.multimesh.mesh = leaves_mesh
	tree_multimesh = MultiMeshInstance3D.new()
	tree_multimesh.multimesh = MultiMesh.new()
	tree_multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	tree_multimesh.multimesh.mesh = tree_mesh
	
	for x in range(-240, 240):
		for y in range(-240, 240):
			if fast_noise.get_noise_2d(x, y) > tree_threshold:
				if (randf() > (1-tree_probability)):
					tree_positions.append(Vector3(x / 10.0, 1, y / 10.0))
	
	tree_multimesh.multimesh.instance_count = tree_positions.size()
	leaves_multimesh.multimesh.instance_count = tree_positions.size()
	
	for i in tree_positions.size():
		add_tree(i, tree_positions[i])
	
	add_child(tree_multimesh)
	add_child(leaves_multimesh)

func add_tree(index : int, tree_pos : Vector3):
	tree_multimesh.multimesh.set_instance_transform(index, Transform3D(Basis(), tree_pos))
	leaves_multimesh.multimesh.set_instance_transform(index, Transform3D(Basis(), tree_pos + Vector3(0.0, 1.0, 0.0)))
