class_name DashToBasicMovement extends MovementBase

@export var distance : float
@export var pauseTime : float

var t = 0

var basic
var dash

func _init():
	basic = BasicMovement.new()
	dash = DashMovement.new()
	super._init()
	
func setPlayer(value):
	basic.player = value
	dash.player = value
	return value

func reset():
	t = 0
	basic.reset()
	dash.distance = distance
	dash.reset()

func input():
	if dash.t > dash.endT:
		basic.input()

func move(delta):
	if dash.t < dash.endT or t < pauseTime:
		dash.move(delta)
		if dash.t >= dash.endT:
			t += delta
	else:
		basic.move(delta)
	
