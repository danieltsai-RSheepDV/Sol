extends Resource
class_name MovementBase

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const speed = 8.0

func setPlayer(p):
	return p

var player :
	set(value):
		player = setPlayer(value)
		
var velocity : Vector3 :
	get:
		return player.velocity
	set(value):
		player.velocity = value
var facingDirection : Vector3 :
	get:
		return player.facingDirection
	set(value):
		player.facingDirection = value
var transform :
	get:
		return player.transform
	

func is_on_floor():
	return player.is_on_floor()
func move_and_slide():
	player.move_and_slide()

func _init(p=null):
	player = p
	pass

func reset():
	pass

func input():
	pass

func move(delta):
	pass
