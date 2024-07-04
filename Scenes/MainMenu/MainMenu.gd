extends Node

@onready var music_player = $MusicPlayer

### BUILT-IN

func _ready():
	$UI/Start_Button/Label/AnimationPlayer.play("Idle")
	music_player.finished.connect(_on_MusicPlayer_finished)
	music_player.play()


### SIGNAL RESPONSES

func _on_start_button_button_up():
#Load Lvl menu
	GAME.goto_scene("res://Scenes/Playground/_Test/AmazingScene.tscn")


func _on_exit_button_button_down():
#Full Quit the game
	get_tree().quit()


func _on_MusicPlayer_finished()->void:
	music_player.play()
