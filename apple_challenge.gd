extends "res://apple_view.gd"

var count = 0
var previous_contact = -1

func _physics_process(delta):
    var player = get_parent().get_node_or_null("Player")
    if not player:
        return

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
    for root in apple_roots:
        root.show()
    render_progress(0, message)