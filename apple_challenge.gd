extends "res://apple_view.gd"

var count = 0
var previous_contact = -1
var apple_positions: Array[Vector3] = []
var win_countdown := 0.0

func _physics_process(delta):
    var player = get_parent().get_node_or_null("Player")
    if not player:
        return

    if win_countdown > 0:
        win_countdown -= delta
        if win_countdown <= 0:
            reset_round("Tap to walk. Collect apples 1–5.")
        return

    if apple_positions.is_empty():
        place_apples()

    var index = -1
    var last_index = previous_contact
    for i in range(5):
        if apple_roots[i].global_position.distance_to(player.global_position) <= 0.65:
            index = i
            break

    previous_contact = index

    if index == last_index or index == -1 or count == 5 or not apple_roots[index].visible:
        return
    if index == count:
        apple_roots[index].hide()
        count += 1
        if count == 5:
            win_countdown = 2.0
            render_progress(5, "You win!")
        else:
            render_progress(count, "Find apple " + str(count + 1))
        return

    reset_round("Wrong order. Find apple 1.")

func _input(event):
    if event is InputEventKey and event.physical_keycode == KEY_R and event.pressed and not event.echo:
        reset_round("Collect apples 1–5 in order.")

func reset_round(message):
    count = 0
    win_countdown = 0.0
    previous_contact = -1
    get_parent().tap_walk.clear()
    apple_positions = get_current_positions()
    place_apples()
    for root in apple_roots:
        root.show()
    render_progress(0, message)

func get_current_positions():
    var current_positions: Array[Vector3] = []
    for root in apple_roots:
        current_positions.append(root.global_position)
    return current_positions

func place_apples():
    var player = get_parent().get_node_or_null("Player")
    if player:
        apple_positions = preload("res://apple_layout.gd").choose(player.global_position, apple_positions)
    for i in range(5):
        apple_roots[i].global_position = apple_positions[i]