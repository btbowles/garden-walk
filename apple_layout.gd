extends RefCounted

class_name AppleLayout

static func choose(player_position: Vector3, previous: Array[Vector3]) -> Array[Vector3]:
    var slots = [
        Vector3(4.7, 0, -3.7),
        Vector3(4.7, 0, -1.2),
        Vector3(4.7, 0, 1.2),
        Vector3(4.7, 0, 3.7),
        Vector3(-4.7, 0, -3.7),
        Vector3(-4.7, 0, -1.2),
        Vector3(-4.7, 0, 1.2),
        Vector3(-4.7, 0, 3.7),
        Vector3(-2.35, 0, 3.7),
        Vector3(0, 0, 3.7),
        Vector3(2.35, 0, 3.7),
        Vector3(2.5, 0, -3.7),
        Vector3(2.5, 0, -1.1)
    ]
    
    slots.shuffle()
    
    var result: Array[Vector3] = []

    for slot in slots:
        if result.size() == 5:
            break

        if previous.size() == 5 and slot == previous[result.size()]:
            continue

        if slot.distance_to(player_position) >= 1.3:
            result.append(slot)

    return result