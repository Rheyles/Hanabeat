extends Control

@export var lvl_number : int

signal on_mouse_hover_lvl(lvl_number)

func _ready():
	if lvl_number < 10:
		get_node("Label").text = "0" + str(lvl_number)
	else:
		get_node("Label").text = str(lvl_number)
	

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
