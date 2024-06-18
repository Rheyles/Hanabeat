extends Node2D

@export var fuseFireParticule: Resource

@onready var sparkShapeCast : ShapeCast2D = $sparkShapeCast

var fuseRef : Node2D
var actualFuseNodePos

var sparkDelay : float = 0.07


#Must contain burn logic ?
#At each step (burn FuseNode 1 by 1) FuseNode check for collision + other logic
#VFX -> move particule at each step
func _burnTheFuse():
	var fuseLine : Line2D = fuseRef.get_node("Line2D")
	while fuseLine.get_point_count() > 0:
		await get_tree().create_timer(sparkDelay).timeout
		_stepBurn(fuseLine)
	fuseRef._lunchFirework()

func _stepBurn(lineToBurn : Line2D):
	
	if sparkShapeCast.is_colliding():	
		var i = sparkShapeCast.get_collision_count()
		while i > 0:
			var colliderFuseNode = sparkShapeCast.get_collider(i-1).get_parent()
			colliderFuseNode.get_node("Sprite2D").modulate = Color.FIREBRICK
			
			i -= 1
	
	lineToBurn.remove_point(lineToBurn.get_point_count()-1)
	
	self.position = lineToBurn.get_point_position(lineToBurn.get_point_count()-1)
