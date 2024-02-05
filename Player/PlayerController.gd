extends CharacterBody3D

@export var cursor : Node3D

#region Lifecycle
func _ready():
	loadScythe(basicScytheAttributes)

func _input(event):
	# Attack input
	if Input.is_action_just_pressed("Attack"):
		attempt_attack()
	
	# Movement
	movementController.input()

func _physics_process(delta):
	# Attack Timer
	attack_timer -= delta
	var curAtk = getCurrentAttack()
	if(curAtk and curAtk._isCompleted()):
		curAtk.remove()
		combo_count = -1
		attack_timer = attack_delay
		movementController = defaultMovement
		movementController.reset()
	
	# Movement
	movementController.move(delta)
#endregion

#region Attack
@onready var basicScytheAttributes = load("res://Player/Weapons/Basic/BasicScytheAttributes.tres")

var attackObjs = []
var movementModules = []

var _pointingDirection = Vector3.LEFT
var pointingDirection : 
	get:
		if combo_count > 0:
			return _pointingDirection
		else:
			var d = cursor.position - position
			d.y = 0
			d = d.normalized()
			_pointingDirection = d
			return d

var combo_count = -1
const attack_delay = 0
var attack_timer = 0

func loadScythe(attr: ScytheAttributes):
	for scn in attr.attacks:
		attackObjs.append(scn.obj.instantiate())
		scn.movement.player = self
		movementModules.append(scn.movement)
		

func attempt_attack():
	if(!getCurrentAttack()):
		if(attack_timer > 0):
			return
		
		combo_count = 0
		
		loadCurrentAttack()
	else:
		var curAtk = getCurrentAttack()
		if(curAtk._isComboReady()):
			curAtk.remove()
			
			combo_count += 1
			
			loadCurrentAttack()
			

func loadCurrentAttack():
	var curAtk = getCurrentAttack()
	curAtk.position = position
	curAtk.init(self)
	owner.add_child(curAtk)
	
	movementController = movementModules[combo_count]
	movementController.reset()
		
func getCurrentAttack():
	if(combo_count >= 0):
		return attackObjs[combo_count]
	else:
		return false
#endregion

#region Movement

var facingDirection = Vector3(1, 0, 0)

var defaultMovement = BasicMovement.new(self)
var movementController = defaultMovement

#endregion
