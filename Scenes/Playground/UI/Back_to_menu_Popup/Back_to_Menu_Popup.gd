extends Control


func set_message(message : String):
	get_node("TextureRect/Label").text = message


### SIGNAL RESPONSES
func _on_cancel_button_zone_button_down():
	#print("Cancel Button Zone")
	self.visible = false


func _on_quit_button_button_down():
	GAME.goto_scene("res://Scenes/LevelSelectionMenu/level_selection_menu.tscn")
