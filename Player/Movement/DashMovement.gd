class_name DashMovement extends MovementBase

@export var distance : float
@export var useDuration : bool
@export var duration : float
var endT
var t = 0
var speedMult

func input():
	pass

func reset():
	if useDuration:
		speedMult = distance / (duration * speed)
	else:
		speedMult = 2
	endT = distance/(speed * speedMult)
	t = 0
	velocity = Vector3.ZERO

func move(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Update Velocity
	if t < endT:
		velocity = facingDirection * speed * speedMult
		t += delta
	else:
		velocity = velocity.move_toward(Vector3.ZERO, 3)
	
	
	move_and_slide()
