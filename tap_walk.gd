extends RefCounted

const Route = preload("res://tap_route.gd")

var waypoints: Array[Vector3] = []

func handle_input(event: InputEvent, camera: Camera3D, start: Vector3, apples: Node) -> void:
	if not event.is_pressed() or not (event is InputEventScreenTouch or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT)):
		return

	if camera == null:
		return

	var screen = event.position

	var apple_targets = []
	for apple in apples.get_children():
		if apple.name in ["Apple1", "Apple2", "Apple3", "Apple4", "Apple5"] and apple.visible:
			var sphere_center = apple.global_position + Vector3(0, 0.42, 0)
			var label_position = apple.global_position + Vector3(0, 1.50, 0)
			var projected_sphere_center = camera.unproject_position(sphere_center)
			var projected_label_position = camera.unproject_position(label_position)
			var distance = min((projected_sphere_center - screen).length(), (projected_label_position - screen).length())
			if distance <= 34:
				apple_targets.append({"apple": apple, "distance": distance})

	if apple_targets.size() > 0:
		apple_targets.sort_custom(func(a, b): return a.distance < b.distance)
		var closest_apple = apple_targets[0].apple
		var target = closest_apple.global_position
		waypoints = Route.plan(start, target)
	else:
		var ray_origin = camera.project_ray_origin(screen)
		var ray_normal = camera.project_ray_normal(screen)
		var plane = Plane(Vector3.UP, 0.0)
		var intersection = plane.intersects_ray(ray_origin, ray_normal)
		if intersection != null:
			waypoints = Route.plan(start, intersection)

func advance(from: Vector3, max_step: float) -> Vector3:
	while waypoints.size() > 0 and waypoints[0].distance_to(from) <= 0.02:
		waypoints.pop_front()

	if waypoints.size() == 0:
		return Vector3.ZERO

	var direction = waypoints[0] - from
	var step = direction.normalized() * min(max_step, direction.length())
	return step

func clear() -> void:
	waypoints.clear()