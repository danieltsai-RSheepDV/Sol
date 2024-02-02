extends CharacterBody3D

const SMALL_NUMBER = 0.1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const speed = 8.0
const accel = 16
const decel = 16
const velPower = 1

# Internal Variables
var targetVelocity = Vector3(0, 0, 0)
var facingDirection = Vector3(1, 0, 0)

func _ready():
	loadScythe(basicScytheAttributes)

func _input(event):
	# Attack input
	if Input.is_action_just_pressed("Attack"):
		attempt_attack()
	# Get movement input
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		targetVelocity = direction * speed
		facingDirection = direction
	else:
		targetVelocity = Vector3.ZERO

func _physics_process(delta):
	if combo_count < 0 || combo_count > 1:
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
	
	# Attack Timer
	attack_timer -= delta
	var curAtk = getCurrentAttack()
	if(curAtk and curAtk._isCompleted()):
		curAtk.remove()
		combo_count = -1
		attack_timer = attack_delay

# Attack
@onready var basicScytheAttributes = load("res://Player/Weapons/Basic/BasicScytheAttributes.tres")

var attackObjs = []

var combo_count = -1
const attack_delay = 0
var attack_timer = 0

func loadScythe(attr: ScytheAttributes):
	for scn in attr.attacks:
		attackObjs.append(scn.instantiate())

func attempt_attack():
	if(!getCurrentAttack()):
		if(attack_timer > 0):
			return
		
		combo_count = 0
		
		var curAtk = getCurrentAttack()
		curAtk.position = position
		curAtk.init(self)
		owner.add_child(curAtk)
	else:
		var curAtk = getCurrentAttack()
		if(curAtk._isComboReady()):
			curAtk.remove()
			
			combo_count += 1
			
			curAtk = getCurrentAttack()
			curAtk.position = position
			curAtk.init(self)
			owner.add_child(curAtk)
		
func getCurrentAttack():
	if(combo_count >= 0):
		return attackObjs[combo_count]
	else:
		return false
