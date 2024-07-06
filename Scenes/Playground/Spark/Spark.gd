extends Area2D
class_name Spark

@export var vapor_scene : Resource

@onready var spark_shape_cast : ShapeCast2D = $sparkShapeCast
@onready var fusenode_shape_cast : ShapeCast2D = $fuseNodeShapeCast

var spark_delay : float = 0.05

### BUILT-IN

func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	_stepBurn()

### LOGIC

func _stepBurn(): 
	EVENTS.emit_signal("spark_nb_changed",1)
	await get_tree().create_timer(spark_delay).timeout
	
	var vapor = vapor_scene.instantiate()
	vapor.global_position = global_position
	GAME.current_scene.get_node("%MouseController").add_child(vapor)

	fusenode_shape_cast.force_shapecast_update()
	var i = fusenode_shape_cast.get_collision_count()
	while i > 0:
		var collider_fuse_node = fusenode_shape_cast.get_collider(i-1).get_parent()
		if collider_fuse_node is FuseNode:
			if not collider_fuse_node.is_burnt :
				collider_fuse_node.display_flash_color()
		i -= 1

	spark_shape_cast.force_shapecast_update()
	i = spark_shape_cast.get_collision_count()
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
