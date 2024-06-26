extends Node2D

@onready var spark_shape_cast : ShapeCast2D = $sparkShapeCast

var fuse_ref : Node2D
var actual_fuse_node_pos
var actual_fuse_node_idx : int

var spark_delay : float = 0.04

### BUILT-IN

func _ready():
	_stepBurn()


### LOGIC

#Must contain burn logic ?
#At each step (burn FuseNode 1 by 1) FuseNode check for collision + other logic
#VFX -> move particule at each step
#func _burnTheFuse():
	#var fuse_line : Line2D = fuse_ref.get_node("Line2D")
	#while actual_fuse_node_idx >= 0:
		#await get_tree().create_timer(spark_delay).timeout
		#_stepBurn(fuse_line)
	#fuse_ref.lunchFirework()


func _stepBurn(): 
	
	await get_tree().create_timer(spark_delay).timeout

	spark_shape_cast.force_shapecast_update()
	var i = spark_shape_cast.get_collision_count()
	while i > 0:
		var collider_fuse_node = spark_shape_cast.get_collider(i-1).get_parent()
		if not collider_fuse_node.is_burnt :
			collider_fuse_node._burn()
		i -= 1
		
	
	#await get_tree().create_timer(spark_delay).timeout
	queue_free()
	#if line_to_burn.get_point_count() > 1: #The Spark souldn't move again if it's the last point to burn
		#self.position = line_to_burn.get_point_position(actual_fuse_node_idx - 1)
	#line_to_burn.remove_point(actual_fuse_node_idx)
	#actual_fuse_node_idx -= 1
