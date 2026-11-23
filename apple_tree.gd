extends Node3D

class_name AppleTree

@export var trunk_radius: float = 0.9
@export var trunk_height: float = 2.4
@export var foliage_radius: float = 1.7
@export var foliage_height: float = 4.2

func _ready():
    # Create trunk
    var trunk = MeshInstance3D.new()
    var trunk_mesh = CylinderMesh.new()
    trunk_mesh.top_radius = 0.65
    trunk_mesh.bottom_radius = 1.0
    trunk_mesh.height = 2.4
    var trunk_material = StandardMaterial3D.new()
    trunk_material.albedo_color = Color(0.6, 0.4, 0.2)
    trunk.mesh = trunk_mesh
    trunk.material_override = trunk_material
    trunk.position = Vector3(0, trunk_height / 2, 0)
    add_child(trunk)

    # Create foliage
    var foliage1 = MeshInstance3D.new()
    var foliage1_mesh = SphereMesh.new()
    foliage1_mesh.radius = 0.85
    foliage1_mesh.height = 1.6
    var foliage1_material = StandardMaterial3D.new()
    foliage1_material.albedo_color = Color(0.2, 0.6, 0.2)
    foliage1.mesh = foliage1_mesh
    foliage1.material_override = foliage1_material
    foliage1.position = Vector3(-0.65, 3.0, 0.25)
    add_child(foliage1)

    var foliage2 = MeshInstance3D.new()
    var foliage2_mesh = SphereMesh.new()
    foliage2_mesh.radius = 0.85
    foliage2_mesh.height = 1.6
    var foliage2_material = StandardMaterial3D.new()
    foliage2_material.albedo_color = Color(0.2, 0.6, 0.2)
    foliage2.mesh = foliage2_mesh
    foliage2.material_override = foliage2_material
    foliage2.position = Vector3(0.70, 2.95, -0.10)
    add_child(foliage2)

    var foliage3 = MeshInstance3D.new()
    var foliage3_mesh = SphereMesh.new()
    foliage3_mesh.radius = 0.85
    foliage3_mesh.height = 1.6
    var foliage3_material = StandardMaterial3D.new()
    foliage3_material.albedo_color = Color(0.2, 0.6, 0.2)
    foliage3.mesh = foliage3_mesh
    foliage3.material_override = foliage3_material
    foliage3.position = Vector3(0, 3.35, 0.1)
    add_child(foliage3)