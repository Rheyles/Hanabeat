extends Node

@onready var music_player = $FireworkVisualizer/MusicPlayer

### BUILT-IN

func _ready():
	$FireworkVisualizer/UI/Start_Button/Label/AnimationPlayer.play("Idle")
	music_player.finished.connect(_on_MusicPlayer_finished)
	music_player.play()
	$FireworkVisualizer/AnimationPlayer.play("fly_in",-1,1.0)


### SIGNAL RESPONSES

func _on_start_button_button_up():
#Load Lvl menu
	$FireworkVisualizer/AnimationPlayer.play("fly_in",-1,-2.0,true)
	await $FireworkVisualizer/AnimationPlayer.animation_finished
	GAME.goto_scene("res://Scenes/LevelSelectionMenu/level_selection_menu.tscn")


func _on_exit_button_button_down():
#Full Quit the game
	get_tree().quit()


func _on_MusicPlayer_finished()->void:
	music_player.play()
