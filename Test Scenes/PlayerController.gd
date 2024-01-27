extends CharacterBody3D

const SMALL_NUMBER = 0.1

const speed = 8.0
const accel = 4
const decel = 4
const velPower = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Internal Variables
var targetVelocity = Vector3(0, 0, 0)

func _process(delta):
	# Get movement input
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		targetVelocity = direction * speed
	else:
		targetVelocity = Vector3.ZERO

func _physics_process(delta):
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

	move_and_slide()
