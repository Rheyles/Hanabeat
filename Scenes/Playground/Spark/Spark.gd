extends Node2D

@onready var spark_shape_cast : ShapeCast2D = $sparkShapeCast

var spark_delay : float = 0.04

### BUILT-IN

func _ready():
	_stepBurn()

### LOGIC

func _stepBurn(): 
	
	await get_tree().create_timer(spark_delay).timeout

	spark_shape_cast.force_shapecast_update()
	var i = spark_shape_cast.get_collision_count()
	while i > 0:
		var collider_fuse_node = spark_shape_cast.get_collider(i-1).get_parent()
		if not collider_fuse_node.is_burnt :
			collider_fuse_node._burn()
		i -= 1
	
	queue_free()
