extends Node2D

@export var fuseLine2D : Resource
@export var fuseNode : Resource

var pressed : bool = false
var mouse_is_on_fuseNode : bool = false
var mouse_is_on_last_fuseNode : bool = false

var current_fuse : Node2D
var hovered_fuse : Node2D

var fuse_list = []

var minNodeDistance : float = 25
var last_node_pos : Vector2 = Vector2.ZERO

### BUILT-INT

func _input(event: InputEvent)-> void:
#Check for 1st click
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
#After 1st click => Create new Fuse and store it in the List "fuse_list"
		if  pressed:
			if (mouse_is_on_fuseNode):
				current_fuse = hovered_fuse
				
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		current_fuse.resetFuse()

#While Mouse Button Left is not release => Add a new line2D point + a FuseNode
#Check for min distance between the last fuseNode Position and Mouse position to reduce the number of point
	if event is InputEventMouseMotion && pressed && mouse_is_on_last_fuseNode:
		#last_node_pos = le last fuse node sous la souris
		if last_node_pos.distance_to(get_local_mouse_position()) >= minNodeDistance:
			current_fuse.get_node("Line2D").add_point(event.position - current_fuse.global_position)
			
#Add the fuseNode at the position of the new Line2D Point
			var node_pos =  current_fuse.get_node("Line2D").get_point_position(current_fuse.get_node("Line2D").get_point_count() -1)
			var newNode = fuseNode.instantiate()
			newNode.position = event.position
			last_node_pos = newNode.position
			newNode.parent_fuse_ref = current_fuse
			newNode.line_point_ref = current_fuse.get_node("Line2D").get_point_count() -1
			add_child(newNode)
			newNode.reparent(current_fuse)
			current_fuse.fuseNode_list.append(newNode)
			newNode.get_node("Area2D").mouse_entered.connect(_On_mouse_enter_fuseNode)
			newNode.get_node("Area2D").mouse_exited.connect(_On_mouse_exit_fuseNode)
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_action_released && !pressed:
			mouse_is_on_last_fuseNode = false
			last_node_pos = Vector2.ZERO
##For Testing Purpose : At release => lunch Burn logic
			#if current_line != null && current_line.get_node("Line2D").get_point_count() > 0:
				#current_line.igniteFuse()
				#print("release")

func _connectFirstFuseNode(newNode):
	newNode.get_node("Area2D").mouse_entered.connect(_On_mouse_enter_fuseNode)
	newNode.get_node("Area2D").mouse_exited.connect(_On_mouse_exit_fuseNode)

### SIGNAL RESPONSES

func _On_mouse_enter_fuseNode():
	mouse_is_on_fuseNode = true;
	#print("MouseController : " + str(mouse_is_on_fuseNode))

func _On_mouse_exit_fuseNode():
	mouse_is_on_fuseNode = false;

	#print("MouseController : " + str(mouse_is_on_fuseNode))

