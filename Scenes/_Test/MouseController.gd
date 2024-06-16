extends Node2D

@export var fuseLine2D : Resource

var pressed : = false
var currentLine : Node2D

var fuseList = []

func _input(event: InputEvent)-> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed = event.pressed

		if  pressed:
			var newfuse = fuseLine2D.instantiate()
			add_child(newfuse)
			currentLine = newfuse
			newfuse.startingPos = event.position
			fuseList.append(newfuse)
	
	if event is InputEventMouseMotion && pressed:
#Ajoute un point à chaque nouveau call du mouvement de la souris
		currentLine.get_node("Line2D").add_point(event.position)
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_action_released && !pressed:
#Action Quand release du clic AKA : relacher la ligne et lancer l'effacement
			currentLine.eraseLine(currentLine.get_node("Line2D"))
			print("release")

