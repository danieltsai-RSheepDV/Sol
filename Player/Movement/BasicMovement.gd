
class_name BasicMovement extends MovementBase

const SMALL_NUMBER = 0.1

const accel = 16
const decel = 16
const velPower = 1

# Internal Variables
var targetVelocity = Vector3(0, 0, 0)

func reset():
	targetVelocity = Vector3.ZERO

func input():
	# Get movement input
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		targetVelocity = direction * speed
		facingDirection = direction
	else:
		targetVelocity = Vector3.ZERO
	pass

func move(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Update Velocity
	var xDif = targetVelocity.x - velocity.x
	var xAccel = accel if (abs(velocity.x) > SMALL_NUMBER) else decel
	velocity.x += delta * pow(abs(xDif) * xAccel, velPower) * sign(xDif)
	
	var zDif = targetVelocity.z - velocity.z
	var zAccel = accel if (abs(velocity.z) > SMALL_NUMBER) else decel
	velocity.z += delta * pow(abs(zDif) * zAccel, velPower) * sign(zDif)
	
	if Input.is_action_just_pressed("Dash"):
		velocity = targetVelocity.normalized() * 50
	
	move_and_slide()
