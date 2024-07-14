extends Control

@export var lvl_number : int

@onready var lvl_score_text = $Lvl_info_display/Lvl_info_text

signal on_mouse_hover_lvl(lvl_number)

func _ready():
	if lvl_number < 10:
		get_node("Label").text = str(lvl_number)
		#get_node("Label").text = "0" + str(lvl_number)
	else:
		get_node("Label").text = str(lvl_number)
	_setScoreText()

func _setScoreText():
	var best_lvl_score = 0
	if PLAYER.current_data['score_by_level'].size() >= lvl_number:
		best_lvl_score = PLAYER.current_data['score_by_level'][lvl_number]
		if best_lvl_score != -1 and best_lvl_score > GAME.WIN_MARGIN:
			get_node("FireWork_Launcher").visible = true
	if best_lvl_score == -1:
		lvl_score_text.text = "Best : -"
	else:
		lvl_score_text.text = "Best : " + str(best_lvl_score)


### SIGNAL RESPONSES

func _on_texture_button_button_down():
	if LEVELS.levels.size() >= lvl_number:
		GAME.current_scene.get_tree().current_scene.play_sound("select")
		
#Dialogue Logic
		GAME.current_scene.get_tree().current_scene.get_node("%Tuto UI").visible = false
		GAME.current_scene.get_tree().current_scene.get_node("%Dialogue_systeme").trigger_dialog(lvl_number)
	else:
		print("PAS de scène dans LEVELS.levels[] pour ce lvl_number")

func _on_texture_button_mouse_entered():
	#print("emit signal from lvl button ")
	emit_signal("on_mouse_hover_lvl",lvl_number)
