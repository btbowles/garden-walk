extends RefCounted
class_name AppleLayout

static func choose(camera: Camera3D, player_position: Vector3, previous: Array[Vector3]) -> Array[Vector3]:
    var rect = camera.get_viewport().get_visible_rect()
    var pool: Array[Vector3] = []
    
    for x in range(1, 10):
        for y in range(1, 10):
            var screen = rect.position + rect.size * Vector2(x / 10.0, y / 10.0)
            var origin = camera.project_ray_origin(screen)
            var normal = camera.project_ray_normal(screen)
            
            var intersection = Plane(Vector3.UP, 0.0).intersects_ray(origin, normal)
            if intersection != null:
                var point = Vector3(intersection.x, 0.0, intersection.z)
                if is_visible(camera, point):
                    pool.append(point)
    
    pool.shuffle()
    var result: Array[Vector3] = []
    
    for candidate in pool:
        if result.size() == 5:
            break
        
        if previous.size() == 5 and candidate == previous[result.size()]:
            continue
        
        if candidate.distance_to(player_position) < 1.3:
            continue
        
        var too_close = false
        for chosen in result:
            if chosen.distance_to(candidate) < 2.0:
                too_close = true
                break
        
        if not too_close:
            result.append(candidate)
    
    return result

static func is_visible(camera: Camera3D, point: Vector3) -> bool:

    # Reject points outside ground x/z ±79.5
    if absf(point.x) > 79.5 or absf(point.z) > 79.5:
        return false

    # Reject points within tree collision
    if absf(point.x) < 1.75 and absf(point.z) < 1.75:
        return false

    var viewport = camera.get_viewport()
    var rect = viewport.get_visible_rect()
    var shorter_dim = minf(rect.size.x, rect.size.y)
    var inset_amount = shorter_dim * 0.08 + 0.72 * rect.size.x / camera.size
    var inset_rect = rect.grow(-inset_amount)

    # Project both points with visual allowance
    var point1 = point + Vector3.UP * 0.42
    var point2 = point + Vector3.UP * 1.55
    var proj1 = camera.unproject_position(point1)
    var proj2 = camera.unproject_position(point2)

    # Check if both points are within the inset rect
    if not inset_rect.has_point(proj1) or not inset_rect.has_point(proj2):
        return false

    # Check if either point is behind the tree
    var tree_aabb = AABB(Vector3(-1.65, 0, -1.65), Vector3(3.3, 4.25, 3.3))
    var camera_dir = camera.global_transform.basis.z
    if tree_aabb.intersects_segment(point1, point1 + camera_dir * 150) != null or tree_aabb.intersects_segment(point2, point2 + camera_dir * 150) != null:
        return false

    return true