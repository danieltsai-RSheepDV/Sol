extends Attack

@export var swingDistance = 1.5
@export var swingWidth = 2
@export var swingDepth = 2
@export var reversed = false

var player
var timeIncrement
var revMult = 1

var t
var dir
var old_pos


func init(p):
	player = p
	revMult = -1 if reversed else 1
	timeIncrement = 0.5 * (1/attackLength)
	
	t = 0
	dir = player.facingDirection
	
	old_pos = position
	
	$Trail3D.clear_points()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	old_pos = position
	
	var t0 = (ease(t, 0.1) - 0.5) * 5
	
	if(t > 0.5):
		t0 = (ease(0.5, 0.1) - 0.5) * 5
	else:
		look_at(player.position + calcLocalPos(t0 + 0.01), Vector3.UP)
	
	position = player.position + calcLocalPos(t0)
	
	t += delta * timeIncrement

func calcLocalPos(t0):
	var localPos = Vector3(swingWidth * sin(t0 * revMult), -t0 * 0.15, swingDepth * (cos(t0) - 0.707106781187) + swingDistance)
	localPos = localPos.rotated(Vector3.UP, Vector3.BACK.signed_angle_to(dir, Vector3.UP))
	return localPos

func _isCompleted():
	return t > 1.4

func _isComboReady():
	return t > 0.3
