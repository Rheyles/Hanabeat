extends Node

@export var select_sound : Resource

@onready var animationPlayer = $AnimationPlayer
@onready var lvl_info_display = $OtherUI/Lvl_info_display/Lvl_info_text
@onready var sound_player = $SoundPlayer

func _ready():
	get_node("SelectionButton/LevelButton0").on_mouse_hover_lvl.connect(_On_Mouse_Over_Lvl)
	get_node("SelectionButton/LevelButton1").on_mouse_hover_lvl.connect(_On_Mouse_Over_Lvl)
	get_node("SelectionButton/LevelButton2").on_mouse_hover_lvl.connect(_On_Mouse_Over_Lvl)
	get_node("SelectionButton/LevelButton3").on_mouse_hover_lvl.connect(_On_Mouse_Over_Lvl)
	get_node("SelectionButton/LevelButton4").on_mouse_hover_lvl.connect(_On_Mouse_Over_Lvl)
	get_node("SelectionButton/LevelButton5").on_mouse_hover_lvl.connect(_On_Mouse_Over_Lvl)

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

func _On_Mouse_Over_Lvl(lvl_number : int):
	var best_lvl_score = 0
	if PLAYER.current_data['score_by_level'].size() >= lvl_number:
		best_lvl_score = PLAYER.current_data['score_by_level'][lvl_number]
	lvl_info_display.text = "Level :  " + str(lvl_number) + " Best Score : " + str(best_lvl_score)
