extends Control

### SIGNAL RESPONSES
func _on_cancel_button_zone_button_down():
	#print("Cancel Button Zone")
	self.visible = false


func _on_quit_button_button_down():
	GAME.goto_scene("res://Scenes/MainMenu/MainMenu.tscn")
