extends Node2D

@export var fuseLine2D : Resource
@export var fuseNode : Resource

var pressed : bool = false
var mouse_is_on_fuseNode : bool = false
var mouse_is_on_last_fuseNode : bool = false

var current_fuse : Node2D
var hovered_fuse : Node2D

var fuse_list = []

var minNodeDistance : float = 10
var last_node_pos : Vector2 = Vector2.ZERO

var slice_start : Vector2 = Vector2.ZERO
signal slice_fuse(start, end)

@onready var slice_line = $SliceLine

### BUILT-INT

func _process(_delta)-> void:
	
	# Manage Input
	if Input.is_action_just_pressed('left_click'):
		pressed = true
		if mouse_is_on_fuseNode:
			current_fuse = hovered_fuse
		else :
			_prep_slice_fuse()
		
	if Input.is_action_just_released("left_click"):
		if not current_fuse and slice_start != Vector2.ZERO :
			_slice_fuse()
			
		pressed = false
		hovered_fuse = current_fuse
		current_fuse = null
		
	if Input.is_action_just_pressed('right_click') and hovered_fuse:
		hovered_fuse.resetFuse()

	#While Mouse Button Left is not release => Add a new line2D point + a FuseNode
	#Check for min distance between the last fuseNode Position and Mouse position to reduce the number of point
	if pressed :
		if current_fuse :
			_create_fuse()
		elif slice_start != Vector2.ZERO:
			_update_slice_fuse()

###LOGIC

func _connectFirstFuseNode(newNode):
	newNode.get_node("Area2D").mouse_entered.connect(_On_mouse_enter_fuseNode)
	newNode.get_node("Area2D").mouse_exited.connect(_On_mouse_exit_fuseNode)

func _create_fuse():
	# last_node_pos = le last fuse node sous la souris		
	var distance_to_mouse = last_node_pos.distance_to(get_local_mouse_position())
	var nb_new_nodes = floor(distance_to_mouse/minNodeDistance)
	var trajectory_vec = (get_local_mouse_position() - last_node_pos).normalized()
	var last_node_pos_mem = last_node_pos
	
	for i in range(1, nb_new_nodes + 1) :
		var node_pos = last_node_pos_mem + (trajectory_vec*i*minNodeDistance) - current_fuse.global_position
		current_fuse.get_node("Line2D").add_point(node_pos)
		
		# Add the fuseNode at the position of the new Line2D Point
		var newNode = fuseNode.instantiate()
		newNode.position = node_pos + current_fuse.global_position
		last_node_pos = newNode.position
		newNode.parent_fuse_ref = current_fuse
		newNode.line_point_ref = current_fuse.get_node("Line2D").get_point_count() -1
		add_child(newNode)
		newNode.reparent(current_fuse)
		current_fuse.fuseNode_list.append(newNode)
		newNode.get_node("Area2D").mouse_entered.connect(_On_mouse_enter_fuseNode)
		newNode.get_node("Area2D").mouse_exited.connect(_On_mouse_exit_fuseNode)

func _prep_slice_fuse():
	slice_start = get_local_mouse_position()
	slice_line.add_point(slice_start)
	slice_line.add_point(slice_start)

func _update_slice_fuse():
	slice_line.set_point_position(1, get_local_mouse_position())
	
func _slice_fuse():
	var slice_end = get_local_mouse_position()
	emit_signal("slice_fuse", slice_start, slice_end)
	slice_line.clear_points()
	slice_start = Vector2.ZERO

### SIGNAL RESPONSES

func _On_mouse_enter_fuseNode():
	mouse_is_on_fuseNode = true;
	#print("MouseController : " + str(mouse_is_on_fuseNode))
	#print(hovered_fuse)

func _On_mouse_exit_fuseNode():
	mouse_is_on_fuseNode = false
	if not pressed:
		hovered_fuse = null

	#print("MouseController : " + str(mouse_is_on_fuseNode))

