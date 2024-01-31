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


func init(p):
	player = p
	revMult = -1 if reversed else 1
	timeIncrement = 0.5 * (1/attackLength)
	
	t = 0
	dir = player.facingDirection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(t < 0.6):
		var t0 = (ease(t, 0.1) - 0.5) * PI/2
		
		var localPos = Vector3(swingWidth * sin(t0 * revMult), 0, swingDepth * (cos(t0) - 0.707106781187) + swingDistance)
		localPos = localPos.rotated(Vector3.UP, Vector3.BACK.signed_angle_to(dir, Vector3.UP))
		position = player.position + localPos
		
		t += delta * timeIncrement

func _isCompleted():
	return t > 0.6

func _isComboReady():
	return t > 0.3
