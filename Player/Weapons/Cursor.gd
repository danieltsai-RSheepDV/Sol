extends Node3D

const RAY_LENGTH = 1000

@export var camera : Camera3D
@export var player : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var space_state = get_world_3d().direct_space_state
	
	var mousePos = get_viewport().get_mouse_position()
	if mousePos == null:
		return
	
	var dropPlane = Plane(Vector3.UP, Vector3(0, player.position.y - 1, 0))
	var dpPos = dropPlane.intersects_ray(camera.project_ray_origin(mousePos), camera.project_ray_normal(mousePos))
	
	if dpPos: position = dpPos
	
