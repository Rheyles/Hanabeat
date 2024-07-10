extends Control


func _ready():
	$TextureRect/Label.text = tr("UI_LEAVE_LVL")


func set_message(message_id : String):
	get_node("TextureRect/Label").text = tr(message_id)


### SIGNAL RESPONSES
func _on_cancel_button_zone_button_down():
	#print("Cancel Button Zone")
	self.visible = false


func _on_quit_button_button_down():
	var parent = get_parent().get_parent()
	if not parent is Level:
		parent.transition_animation.play("fly_in", -1, -1.0, true)
	else :
		parent.transition_animation.play("Transi_IN", -1, -1.0, true)
	await parent.transition_animation.animation_finished		
	GAME.goto_scene("res://Scenes/LevelSelectionMenu/level_selection_menu.tscn")
