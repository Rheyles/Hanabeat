extends Node2D

@export var fuseLine2D : Resource
@export var fuseNode : Resource

var pressed : = false
var current_line : Node2D

var fuse_list = []

var minNodeDistance : float = 25
var last_node_pos

### BUILT-INT

func _input(event: InputEvent)-> void:
#Check for 1st click
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed = event.pressed
#After 1st click => Create new Fuse and store it in the List "fuse_list"
		if  pressed:
			var newfuse = fuseLine2D.instantiate()
			add_child(newfuse)
			current_line = newfuse
			newfuse.starting_pos = event.position 
			fuse_list.append(newfuse)
			newfuse.fuse_idx = fuse_list.size()-1
			
#While Mouse Button Left is not release => Add a new line2D point + a FuseNode
#Check for min distance between the last fuseNode Position and Mouse position to reduce the number of point
	if event is InputEventMouseMotion && pressed:
		last_node_pos = current_line.get_node("Line2D").get_point_position(current_line.get_node("Line2D").get_point_count() -1)
		
		if last_node_pos.distance_to(get_local_mouse_position()) >= minNodeDistance:
			current_line.get_node("Line2D").add_point(event.position)
#Add the fuseNode at the position of the new Line2D Point
			var node_pos =  current_line.get_node("Line2D").get_point_position(current_line.get_node("Line2D").get_point_count() -1)
			var newNode = fuseNode.instantiate()
			
			if current_line.get_node("Line2D").get_point_count() == 1:
				current_line.first_node = newNode
				
			newNode.position = node_pos
			newNode.parent_fuse_ref = current_line
			newNode.line_point_ref = current_line.get_node("Line2D").get_point_count() -1
			add_child(newNode)
			newNode.reparent(current_line)
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_action_released && !pressed:
#For Testing Purpose : At release => lunch Burn logic
			current_line._eraseLine()
			print("release")

