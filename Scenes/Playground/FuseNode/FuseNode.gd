extends Node2D
class_name FuseNode

const spark_scene = preload("res://Scenes/Playground/Spark/Spark.tscn")

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

### LOGIC

func _renameAtInstantiate():
	self.name = "FuseNode_" + str(line_point_ref)

func _burn():
	#Visual Feedback
	is_burnt = true
	emit_signal("burnt", parent_fuse_ref.fuse_idx)
	start_new_burn_point()
		
	get_node("Sprite2D").modulate = Color.FIREBRICK

func start_new_burn_point():
	parent_fuse_ref.is_burning = true
	var newSpark = spark_scene.instantiate()
	get_parent().add_child(newSpark)
	newSpark.position = parent_fuse_ref.get_node("Line2D").get_point_position(line_point_ref)
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

