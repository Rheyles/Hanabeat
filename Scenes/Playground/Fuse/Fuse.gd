extends Node2D

@export var fuseNode_scene : Resource
@export var first_node_sprite : Resource
@export var first_node_burnt_sprite : Resource

var fuse_idx : int = 0
var is_burning : bool = false

var starting_pos : Vector2
var first_node
var fuseNode_list = []


func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	_createFirstFuseNode()
	GAME.current_scene.get_node("%MouseController").slice_fuse.connect(_on_Slice)

### LOGIC

func _createFirstFuseNode():
	var newNode = fuseNode_scene.instantiate()
	first_node = newNode
	newNode.parent_fuse_ref = self
	newNode.fuseNode_idx = 0
	newNode.get_node("fuseSprite").texture = first_node_sprite
	newNode.get_node("Sprite2D").visible = true
	add_child(newNode)
	fuseNode_list.append(newNode)
	GAME.current_scene.get_node("%MouseController")._connectFirstFuseNode(newNode)

func resetFuse():
	for i in range(len(fuseNode_list)):
		fuseNode_list[i].queue_free()
	fuseNode_list.clear()
	_createFirstFuseNode()

func update_gradient():
	for i in range(len(fuseNode_list)):
		var node_position_in_fuse : float 
		node_position_in_fuse = (float(fuseNode_list[i].fuseNode_idx) / float(fuseNode_list.size()))
		fuseNode_list[i].fuse_sprite.self_modulate = Color.WHITE
		if node_position_in_fuse >= 0.20:
			fuseNode_list[i].fuse_sprite.self_modulate = Color(1,1 - (node_position_in_fuse/3) ,1)


### SIGNAL RESPONSES

func _on_Slice(start:Vector2, end:Vector2)->void:
	var slice_vec = start - end
	var first_node_side = slice_vec.angle_to(start - first_node.global_position)
	var last_node_idx = 0
	
	for fuseNode in fuseNode_list:
		var node_angle = slice_vec.angle_to(start - fuseNode.global_position)
		if sign(node_angle) != sign(first_node_side) && \
				fuseNode.global_position.distance_to(start) + \
				   fuseNode.global_position.distance_to(end) < slice_vec.length() + 25 && \
				node_angle < 0.2 :
			last_node_idx = fuseNode.fuseNode_idx
			break
	
	if last_node_idx != 0 :
		for _i in range(len(fuseNode_list) - last_node_idx):
			fuseNode_list[last_node_idx].queue_free()
			fuseNode_list.remove_at(last_node_idx)
	update_gradient()
	fuseNode_list.back().get_node("Sprite2D").visible = true


func _on_EVENTS_has_detonated(new_value:bool)->void:
	if not new_value :
		update_gradient()
		fuseNode_list.back().get_node("Sprite2D").visible = true
