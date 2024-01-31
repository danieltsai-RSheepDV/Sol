extends Node3D
class_name Attack

@export var attackLength: float

func remove():
	get_parent().remove_child(self)
	
func isActive():
	return true if get_parent() else false

func _isCompleted():
	print(self.get_name() + "Didn't implement isCompleted!!")
	

func _isComboReady():
	print(self.get_name() + "Didn't implement isComboReady!!")
