extends Node3D

@export var apple_roots: Array[Node3D]

var status_label: Label
var h_box_container: HBoxContainer

func _ready():
    for i in range(5):
        var root = Node3D.new()
        root.name = "Apple" + str(i + 1)
        root.position = Vector3(4, 0, 3.5) if i == 0 else Vector3(4, 0, -3) if i == 1 else Vector3(0, 0, -3.5) if i == 2 else Vector3(-4, 0, -3) if i == 3 else Vector3(-4, 0, 3)
        add_child(root)
        apple_roots.append(root)

        var mesh_instance = MeshInstance3D.new()
        mesh_instance.mesh = SphereMesh.new()
        mesh_instance.position = Vector3(0, 0.42, 0)
        mesh_instance.material_override = StandardMaterial3D.new()
        mesh_instance.material_override.albedo_color = Color(1, 0, 0)
        root.add_child(mesh_instance)

        var label = Label3D.new()
        label.text = str(i + 1)
        label.position = Vector3(0, 1.15, 0)
        label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
        label.modulate = Color(1, 1, 1)
        label.outline_modulate = Color(0, 0, 0)
        root.add_child(label)

    var v_box_container = VBoxContainer.new()
    v_box_container.position = Vector2(16, 12)
    add_child(v_box_container)

    status_label = Label.new()
    status_label.text = "Walk into 1-5 and press R to replay"
    v_box_container.add_child(status_label)

    h_box_container = HBoxContainer.new()
    h_box_container.name = "Collected"
    v_box_container.add_child(h_box_container)

func render_progress(count: int, message: String):
    status_label.text = message
    for child in h_box_container.get_children():
        h_box_container.remove_child(child)
        child.queue_free()
    for i in range(count):
        var label = Label.new()
        label.text = str(i + 1)
        var style = StyleBoxFlat.new()
        style.bg_color = Color(1, 0, 0)
        style.set_corner_radius_all(8)
        label.add_theme_stylebox_override("normal", style)
        label.custom_minimum_size = Vector2(32, 30)
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        h_box_container.add_child(label)