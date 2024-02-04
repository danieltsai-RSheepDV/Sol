extends Resource
class_name ScytheAttributes

@export var attacks:Array[AttackAttributes]

class AttackInfo:
	var scene: PackedScene
	var attackLength: float

func numAttacks() -> int:
	return attacks.size()
	
