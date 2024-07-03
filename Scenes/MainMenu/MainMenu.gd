extends Node

### SIGNAL RESPONSES

func _on_start_button_button_up():
#Load Lvl menu
	GAME.goto_scene("res://Scenes/Playground/_Test/TouchTest.tscn")


func _on_exit_button_button_down():
#Full Quit the game
	get_tree().quit()
