extends Node2D

@onready var spark_shape_cast : ShapeCast2D = $sparkShapeCast

var spark_delay : float = 0.05

### BUILT-IN

func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	_stepBurn()

### LOGIC

func _stepBurn(): 
	EVENTS.emit_signal("spark_nb_changed",1)
	await get_tree().create_timer(spark_delay).timeout

	spark_shape_cast.force_shapecast_update()
	var i = spark_shape_cast.get_collision_count()
	while i > 0:
		var collider_fuse_node = spark_shape_cast.get_collider(i-1).get_parent()
		if not collider_fuse_node.is_burnt :
			collider_fuse_node._burn()
		i -= 1
	
	destroy()

func destroy():
	EVENTS.emit_signal("spark_nb_changed",-1)
	queue_free()

### SIGNAL LOGICS

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if not new_value:
		destroy()
