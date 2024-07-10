extends Node

@export var select_sound : Resource

@onready var animationPlayer = $AnimationPlayer
@onready var sound_player = $SoundPlayer


func play_sound(sound_name:String)->void:
	if sound_name == "select":
		sound_player.stream = select_sound
		sound_player.pitch_scale = 1
	sound_player.play()

### SIGNAL RESPONSES

func _on_back_menu_button_button_down():
#Load Lvl menu
	play_sound("select")
	animationPlayer.play("Transi_IN",-1,-1,true)
	await animationPlayer.animation_finished
	GAME.goto_scene("res://Scenes/MainMenu/MainMenu.tscn")
