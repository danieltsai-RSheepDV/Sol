class_name DashMovement extends MovementBase

const bias = 0.6

@export var distance : float
@export var useDuration : bool
@export var duration : float
var endT
var t = 0
var speedMult
var moving

func input():
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	moving = true if input_dir else false

func reset():
	if useDuration:
		speedMult = distance / (duration * speed)
	else:
		speedMult = 2
	endT = distance/(speed * speedMult)
	t = 0
	velocity = Vector3.ZERO

func move(delta):
	# Update Velocity
	if t < endT:
		var combinedDir = (player.pointingDirection * bias + facingDirection * (1 - bias)).normalized() if moving else player.pointingDirection * 0.3
		velocity = combinedDir * speed * speedMult
		t += delta
	else:
		velocity = velocity.move_toward(Vector3.ZERO, 3)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
