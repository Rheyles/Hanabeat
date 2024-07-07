extends Node

@onready var music_player = $FireworkVisualizer/MusicPlayer

### BUILT-IN

func _ready():
	$FireworkVisualizer/UI/StartLabel/AnimationPlayer.play("Idle")
	$FireworkVisualizer/AnimationPlayer.play("fly_in",-1,1.0)

func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		#Load Lvl menu
		$FireworkVisualizer/AnimationPlayer.play("fly_in",-1,-2.0,true)
		await $FireworkVisualizer/AnimationPlayer.animation_finished
		GAME.goto_scene("res://Scenes/LevelSelectionMenu/level_selection_menu.tscn")

### SIGNAL RESPONSES

func _on_exit_button_button_down():
#Full Quit the game
	get_tree().quit()

