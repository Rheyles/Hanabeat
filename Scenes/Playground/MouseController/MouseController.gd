extends Node2D

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

func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)

func _process(_delta)-> void:
	
	# Manage Input
	if Input.is_action_just_pressed('left_click') and not GAME.has_detonated:
		pressed = true
		if mouse_is_on_fuseNode:
			current_fuse = hovered_fuse
		else :
			_prep_slice_fuse()
		
	if Input.is_action_just_released("left_click") and not GAME.has_detonated:
		if not current_fuse and slice_start != Vector2.ZERO :
			_slice_fuse()
			
		pressed = false
		hovered_fuse = current_fuse
		current_fuse = null
		mouse_is_on_last_fuseNode = false
		
	if Input.is_action_just_pressed('right_click') and hovered_fuse and not GAME.has_detonated:
		hovered_fuse.resetFuse()
		
	if pressed :
		if current_fuse && mouse_is_on_last_fuseNode:
			_create_fuse()
		elif slice_start != Vector2.ZERO:
			_update_slice_fuse()

###LOGIC

func _connectFirstFuseNode(newNode):
	newNode.get_node("Area2D").mouse_entered.connect(_On_mouse_enter_fuseNode)
	newNode.get_node("Area2D").mouse_exited.connect(_On_mouse_exit_fuseNode)

func _create_fuse():
	var distance_to_mouse = last_node_pos.distance_to(get_local_mouse_position())
	var nb_new_nodes = floor(distance_to_mouse/minNodeDistance)
	var trajectory_vec = (get_local_mouse_position() - last_node_pos).normalized()
	var last_node_pos_mem = last_node_pos
	
	for i in range(1, nb_new_nodes + 1) :
		var node_pos = last_node_pos_mem + (trajectory_vec*i*minNodeDistance) - current_fuse.global_position
		
		var newNode = fuseNode.instantiate()
		newNode.position = node_pos + current_fuse.global_position
		last_node_pos = newNode.position
		newNode.parent_fuse_ref = current_fuse
		newNode.rotation = trajectory_vec.angle()
		add_child(newNode)
		newNode.reparent(current_fuse)
		current_fuse.fuseNode_list.append(newNode)
		newNode.fuseNode_idx = current_fuse.fuseNode_list.size()-1
		
		newNode.get_node("Area2D").mouse_entered.connect(_On_mouse_enter_fuseNode)
		newNode.get_node("Area2D").mouse_exited.connect(_On_mouse_exit_fuseNode)
		
		current_fuse.update_gradient()

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

func _On_mouse_exit_fuseNode():
	mouse_is_on_fuseNode = false
	if not pressed:
		hovered_fuse = null

func _on_EVENTS_has_detonated(_new_value:bool)->void:
	slice_line.clear_points()
	slice_start = Vector2.ZERO
	pressed = false
	hovered_fuse = current_fuse
	current_fuse = null
	mouse_is_on_last_fuseNode = false
