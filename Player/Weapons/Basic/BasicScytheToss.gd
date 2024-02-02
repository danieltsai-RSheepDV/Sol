extends Attack

@export var speed = 40.0
@export var arcSpeed = 2.0
@export var maxDistance = 8.0
@export var arcSize = 2.0

var deceleration
var player

var completed = false
var curSpeed
var target

var t
var endT
var dir
var direction

func init(p):
	player = p
	deceleration = (speed * speed) / (2 * maxDistance)
	
	dir = player.facingDirection
	dir.y = 0
	dir = dir.normalized()
	t = -2.5
	endT = -acos(arcSize / maxDistance)
	print(endT)
	
	curSpeed = speed + player.velocity.length()
	completed = false
	
	$Trail3D.clear_points()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if completed:
		return
	
	if(t < endT):
		position = player.position + calcLocalPos(t)
	
		t += delta * (speed/arcSize)
		direction = (dir * maxDistance - calcLocalPos(t))
		direction.y = 0
		direction = direction.normalized()
		look_at(player.position + calcLocalPos(t + 0.05), Vector3.UP)
		return
	
	position += direction * (delta * curSpeed)
	curSpeed -= deceleration * delta
	
	if(curSpeed < 0):
		direction = (position - player.position)
		direction = direction.normalized()
		
		if(position.distance_to(player.position) < 0.1):
			completed = true

func calcLocalPos(t0):
	var localPos = Vector3(-arcSize * sin(t0), t0 * 0.15, arcSize * (cos(t0) - 0.707106781187) + arcSize/2)
	localPos = localPos.rotated(Vector3.UP, Vector3.BACK.signed_angle_to(dir, Vector3.UP))
	return localPos

func _isCompleted():
	return completed

func _isComboReady():
	return false
