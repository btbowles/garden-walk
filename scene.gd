extends Node3D

const FLOOR_HALF := Vector2(6.0, 5.0)
const PROP_HALF := Vector2(1.0, 1.0)
const PLAYER_RADIUS := 0.5
const SPEED := 4.0

var player: Node3D
var foot1: MeshInstance3D
var foot2: MeshInstance3D
var phase := 0.0

func _ready() -> void:
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = Color("#adc9be")
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color("#f5e4cb")
	environment.environment.ambient_light_energy = 0.45
	add_child(environment)

	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-50, -32, 0)
	light.shadow_enabled = true
	add_child(light)

	_box(self, Vector3(0, -0.3, 0), Vector3(12, 0.6, 10), Color("#6eaa73"))
	var apple_tree = preload("res://apple_tree.gd")
	var apple_tree_instance = apple_tree.new()
	apple_tree_instance.name = "AppleTree"
	add_child(apple_tree_instance)
	for x in [-4.0, -2.0, 2.0, 4.0]:
		_box(self, Vector3(x, 0.005, -3.4), Vector3(0.72, 0.01, 0.48), Color("#cbd1a0"))

	player = Node3D.new()
	player.name = "Player"
	add_child(player)
	player.position = Vector3(3, 0, 2)
	_box(player, Vector3(0, 0.65, 0), Vector3(0.68, 0.74, 0.62), Color("#316b79"))
	_box(player, Vector3(0, 1.2, 0), Vector3(0.66, 0.54, 0.62), Color("#ffc78a"))
	_box(player, Vector3(0, 1.14, 0.34), Vector3(0.18, 0.13, 0.12), Color("#6a4140"))
	foot1 = _box(player, Vector3(-0.2, 0.16, 0), Vector3(0.24, 0.24, 0.36), Color("#30354e"))
	foot2 = _box(player, Vector3(0.2, 0.16, 0), Vector3(0.24, 0.24, 0.36), Color("#30354e"))

	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.size = maxf(17.4, 11.0 * get_viewport().get_visible_rect().size.aspect())
	camera.position = Vector3(8, 10, 11)
	add_child(camera)
	camera.look_at(Vector3.ZERO)
	camera.make_current()
	get_viewport().size_changed.connect(func(): camera.size = maxf(17.4, 11.0 * get_viewport().get_visible_rect().size.aspect()))

func _box(parent: Node3D, at: Vector3, dimensions: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var shape := BoxMesh.new()
	shape.size = dimensions
	node.mesh = shape
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	node.material_override = material
	parent.add_child(node)
	node.position = at
	return node

func _axis(positive: Key, positive_arrow: Key, negative: Key, negative_arrow: Key) -> float:
	return float(Input.is_physical_key_pressed(positive) or Input.is_physical_key_pressed(positive_arrow)) - float(Input.is_physical_key_pressed(negative) or Input.is_physical_key_pressed(negative_arrow))

func _walkable(at: Vector3) -> bool:
	return absf(at.x) >= PROP_HALF.x + PLAYER_RADIUS or absf(at.z) >= PROP_HALF.y + PLAYER_RADIUS

const TapWalk = preload("res://tap_walk.gd")
var tap_walk = TapWalk.new()

func _unhandled_input(event: InputEvent) -> void:
	if player:
		tap_walk.handle_input(event, get_viewport().get_camera_3d(), player.position, get_node_or_null("Apples"))

func _physics_process(delta: float) -> void:
	var direction := Vector3(_axis(KEY_D, KEY_RIGHT, KEY_A, KEY_LEFT), 0, _axis(KEY_S, KEY_DOWN, KEY_W, KEY_UP)).normalized()
	var previous := player.position
	var step := direction * SPEED * delta

	if direction == Vector3.ZERO:
		step = tap_walk.advance(previous, SPEED * delta)
		direction = step.normalized()
	else:
		tap_walk.clear()
	var next_x := Vector3(clampf(previous.x + step.x, -FLOOR_HALF.x + PLAYER_RADIUS, FLOOR_HALF.x - PLAYER_RADIUS), 0, previous.z)
	if _walkable(next_x):
		player.position = next_x
	var next_z := Vector3(player.position.x, 0, clampf(previous.z + step.z, -FLOOR_HALF.y + PLAYER_RADIUS, FLOOR_HALF.y - PLAYER_RADIUS))
	if _walkable(next_z):
		player.position = next_z
	if not direction.is_zero_approx():
		player.rotation.y = atan2(direction.x, direction.z)
	phase = phase + delta * 12.0 if not player.position.is_equal_approx(previous) else 0.0
	foot1.rotation.x = sin(phase) * 0.5
	foot2.rotation.x = -foot1.rotation.x
