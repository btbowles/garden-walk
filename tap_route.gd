extends RefCounted

class_name TapRoute

static func plan(start: Vector3, goal: Vector3) -> Array[Vector3]:
    if start == goal:
        return []

    if abs(goal.x) > 79.5 or abs(goal.z) > 79.5 or (abs(goal.x) < 1.5 and abs(goal.z) < 1.5):
        return []

    var fixed_aabb = AABB(Vector3(-1.499, -1, -1.499), Vector3(2.998, 2, 2.998))

    if fixed_aabb.intersects_segment(start, goal) == null:
        return [goal]

    var candidates = []
    var lane_z = 1.8
    var lane_x = 1.8

    # Lane Z
    var path_z1 = [Vector3(start.x, 0, lane_z), Vector3(goal.x, 0, lane_z), goal]
    var path_z2 = [Vector3(start.x, 0, -lane_z), Vector3(goal.x, 0, -lane_z), goal]

    # Lane X
    var path_x1 = [Vector3(lane_x, 0, start.z), Vector3(lane_x, 0, goal.z), goal]
    var path_x2 = [Vector3(-lane_x, 0, start.z), Vector3(-lane_x, 0, goal.z), goal]

    candidates.append(path_z1)
    candidates.append(path_z2)
    candidates.append(path_x1)
    candidates.append(path_x2)

    var valid_paths = []
    for path in candidates:
        var valid = true
        var previous = start
        for i in range(0, path.size()):
            var point = path[i]
            if previous == point:
                continue
            
            if fixed_aabb.intersects_segment(previous, point) != null:
                valid = false
                break
            
            previous = point
        
        if valid:
            valid_paths.append(path)

    if valid_paths.size() == 0:
        return []

    var typed_array: Array[Vector3] = []
    typed_array.assign(valid_paths[0])
    return typed_array