extends Node2D
class_name FuseNode

@onready var area2D = $Area2D

var parent_fuse_ref
var line_point_ref : int #Ref of the index of the Line2D point link to this FuseNode

var mouse_is_in : bool = false

var is_burnt : bool = false

signal burnt(fuse_idx)

### BUILT-IN

func _ready():
	area2D.mouse_entered.connect(_on_ClickArea_mouse_entered)
	area2D.mouse_exited.connect(_on_ClickArea_mouse_exited)
	
	_renameAtInstantiate()
	_checkForOtherFuseNode()
	_checkForDetonator()

### LOGIC

func _renameAtInstantiate():
	self.name = "FuseNode_" + str(line_point_ref)

func _burn():
#Visual Feedback
	is_burnt = true
	emit_signal("burnt", parent_fuse_ref.fuse_idx)
	#if !parent_fuse_ref.is_burning:
	start_new_burn_point()
		
	get_node("Sprite2D").modulate = Color.FIREBRICK

func _checkForDetonator():
	var detonator = get_tree().current_scene.get_node("%Detonator")
	if global_position.distance_to(detonator.global_position) <= 50:
		print("In range of detonator")
		detonator.connect_new_fuse(parent_fuse_ref)
	

func _checkForOtherFuseNode():
#At instantiate => Check for colision with other FuseNode Collider ? Instance "knot sprite" for visual fb ?
	#On ne peut pas check physic à l'instantiate, il faut attendre les physics step, donc à delay avec un timer
	if area2D.has_overlapping_areas():
		var i = area2D.get_overlapping_areas().size()
		var areas = area2D.get_overlapping_areas()
		while i > 0:
			var collider_fuseNode = areas[i-1].get_parent()
			print(collider_fuseNode.name)
			collider_fuseNode.get_node("Sprite2D").modulate = Color.GREEN_YELLOW
			
			i -= 1

func start_new_burn_point():
	parent_fuse_ref.is_burning = true
	var newSpark = parent_fuse_ref.spark_scene.instantiate()
	newSpark.actual_fuse_node_pos = parent_fuse_ref.get_node("Line2D").get_point_position(line_point_ref)
	newSpark.actual_fuse_node_idx = line_point_ref
	newSpark.fuse_ref = parent_fuse_ref
	add_child(newSpark)
	newSpark.reparent(parent_fuse_ref)
	newSpark.position = parent_fuse_ref.get_node("Line2D").get_point_position(line_point_ref)
	#newSpark._stepBurn()
	print("new burn on FuseNode n° : " + str(line_point_ref))

### SIGNAL RESPONSES

func _on_ClickArea_mouse_entered() -> void:
	mouse_is_in = true
	if parent_fuse_ref != null:
		get_tree().current_scene.get_node("%MouseController").hovered_fuse = parent_fuse_ref
	if line_point_ref == parent_fuse_ref.get_node("Line2D").get_point_count()-1:
		get_tree().current_scene.get_node("%MouseController").mouse_is_on_last_fuseNode = true
		get_tree().current_scene.get_node("%MouseController").last_node_pos = global_position


func _on_ClickArea_mouse_exited() -> void:
	mouse_is_in = false

