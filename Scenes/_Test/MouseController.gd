extends Node2D

@export var fuseLine2D : Resource
@export var fuseNode : Resource

var pressed : = false
var currentLine : Node2D

var fuseList = []

var minNodeDistance : float = 25
var lastNodePos

func _input(event: InputEvent)-> void:
#Check for 1st click
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed = event.pressed
#After 1st click => Create new Fuse and store it in the List "fuseList"
		if  pressed:
			var newfuse = fuseLine2D.instantiate()
			add_child(newfuse)
			currentLine = newfuse
			newfuse.startingPos = event.position 
			fuseList.append(newfuse)
			
#While Mouse Button Left is not release => Add a new line2D point + a FuseNode
#Check for min distance between the last fuseNode Position and Mouse position to reduce the number of point
	if event is InputEventMouseMotion && pressed:
		lastNodePos = currentLine.get_node("Line2D").get_point_position(currentLine.get_node("Line2D").get_point_count() -1)
		
		if lastNodePos.distance_to(get_local_mouse_position()) >= minNodeDistance:
			currentLine.get_node("Line2D").add_point(event.position)
#Add the fuseNode at the position of the new Line2D Point
			var nodePose =  currentLine.get_node("Line2D").get_point_position(currentLine.get_node("Line2D").get_point_count() -1)
			var newNode = fuseNode.instantiate()
			newNode.position = nodePose
			newNode.linePointRef = currentLine.get_node("Line2D").get_point_count() -1
			newNode._renameAtInstantiate()
			add_child(newNode)
			newNode.reparent(currentLine)
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_action_released && !pressed:
#For Testing Purpose : At release => lunch Burn logic
			currentLine.eraseLine(currentLine.get_node("Line2D"))
			print("release")

