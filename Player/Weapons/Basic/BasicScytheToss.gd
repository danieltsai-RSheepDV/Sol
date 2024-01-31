extends Attack

@export var speed = 40
@export var maxDistance = 4

var deceleration
var player

var completed = false
var curSpeed
var direction

func init(p):
	player = p
	deceleration = (speed * speed) / (2 * maxDistance)
	
	direction = player.facingDirection
	direction.y = 0
	direction = direction.normalized()
	
	curSpeed = speed + player.velocity.length()
	completed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if completed:
		return
	
	position += direction * (delta * curSpeed)
	curSpeed -= deceleration * delta
	
	if(curSpeed < 0):
		direction = (position - player.position)
		direction = direction.normalized()
		
		if(position.distance_to(player.position) < 0.1):
			completed = true

func _isCompleted():
	return completed

func _isComboReady():
	return false
