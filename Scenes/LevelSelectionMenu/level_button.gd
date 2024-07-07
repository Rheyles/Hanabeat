extends Control

@export var lvl_number : int

@onready var lvl_score_text = $Lvl_info_display/Lvl_info_text

signal on_mouse_hover_lvl(lvl_number)

func _ready():
	if lvl_number < 10:
		get_node("Label").text = "0" + str(lvl_number)
	else:
		get_node("Label").text = str(lvl_number)
	_setScoreText()

func _setScoreText():
	var best_lvl_score = 0
	if PLAYER.current_data['score_by_level'].size() >= lvl_number:
		best_lvl_score = PLAYER.current_data['score_by_level'][lvl_number]
		get_node("FireWork_Launcher").visible = true
	lvl_score_text.text = "Best : " + str(best_lvl_score)


### SIGNAL RESPONSES

func _on_texture_button_button_down():
	if LEVELS.levels.size() >= lvl_number:
		GAME.current_scene.get_tree().current_scene.play_sound("select")
		var animationPlayer = GAME.current_scene.get_node("AnimationPlayer")
		animationPlayer.play("Transi_IN",-1,-1,true)
		await animationPlayer.animation_finished
		GAME.goto_scene(LEVELS.levels[lvl_number])
	else:
		print("PAS de scène dans LEVELS.levels[] pour ce lvl_number")

func _on_texture_button_mouse_entered():
	#print("emit signal from lvl button ")
	emit_signal("on_mouse_hover_lvl",lvl_number)
