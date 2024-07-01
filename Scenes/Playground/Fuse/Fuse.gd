extends Node2D

const fuseNode_scene = preload("res://Scenes/Playground/FuseNode/FuseNode.tscn")
@export var first_node_sprite : Resource
@export var first_node_burnt_sprite : Resource

var fuse_idx : int = 0
var is_burning : bool = false

var starting_pos : Vector2
var first_node
var fuseNode_list = []

@onready var fuse_line = $Line2D

func _ready():
	_createFirstFuseNode()
	get_tree().current_scene.get_node("%MouseController").slice_fuse.connect(_on_Slice)

### LOGIC

func _createFirstFuseNode():
	var current_line = get_node("Line2D")
	current_line.set_point_position(0,starting_pos)
	var newNode = fuseNode_scene.instantiate()
	first_node = newNode
	newNode.position = current_line.get_point_position(0)
	newNode.parent_fuse_ref = self
	newNode.line_point_ref = 0
	newNode.get_node("fuseSprite").texture = first_node_sprite
	add_child(newNode)
	fuseNode_list.append(newNode)
	
	get_tree().current_scene.get_node("%MouseController")._connectFirstFuseNode(newNode)
	newNode.burnt.connect(_on_node_burnt)

func connect_newNode(newNode : Node2D):
	newNode.burnt.connect(_on_node_burnt)

func resetFuse():
	for i in range(len(fuseNode_list)):
		fuseNode_list[i].queue_free()
	fuseNode_list.clear()
	_createFirstFuseNode()
	fuse_line.clear_points()
	fuse_line.add_point(Vector2.ZERO)

func update_gradient():
	for i in range(len(fuseNode_list)):
		var node_position_in_fuse : float 
		node_position_in_fuse = (float(fuseNode_list[i].line_point_ref) / float(fuseNode_list.size()))
		fuseNode_list[i].fuse_sprite.self_modulate = Color.WHITE
		if node_position_in_fuse >= 0.30:
			fuseNode_list[i].fuse_sprite.self_modulate = Color(1,1 - (node_position_in_fuse/2) ,1)


### SIGNAL RESPONSES

func _on_node_burnt(parent_fuse_ref : int, line_point_ref : int):
	if parent_fuse_ref == fuse_idx:
		var current_line = get_node("Line2D")
		current_line.remove_point(current_line.get_point_count()-1)
		var lineburnt = get_node("Lineburnt")
		lineburnt.clear_points()
		for i in range(len(fuseNode_list)):
			if fuseNode_list[i].is_burnt:
				lineburnt.add_point(fuseNode_list[i].position)

func _on_Slice(start:Vector2, end:Vector2)->void:
	#print('slice signal received')
	var slice_vec = start - end
	var first_node_side = slice_vec.angle_to(start - first_node.global_position)
	var last_node_idx = 0
	
	for fuseNode in fuseNode_list:
		var node_angle = slice_vec.angle_to(start - fuseNode.global_position)
		if sign(node_angle) != sign(first_node_side) && \
				fuseNode.global_position.distance_to(start) + \
				   fuseNode.global_position.distance_to(end) < slice_vec.length() + 25 && \
				node_angle < 0.2 :
			last_node_idx = fuseNode.line_point_ref
			break
	
	if last_node_idx != 0 :
		for _i in range(len(fuseNode_list) - last_node_idx):
			fuseNode_list[last_node_idx].queue_free()
			fuseNode_list.remove_at(last_node_idx)
			fuse_line.remove_point(last_node_idx)
