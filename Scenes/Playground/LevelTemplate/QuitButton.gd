extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	var parent = get_parent().get_parent()
	if not parent is Level:
		parent.transition_animation.play("fly_in", -1, -1.0, true)
		GAME.from_position_scene_music = parent.get_node("MusicPlayer").get_playback_position()
	else :
		parent.transition_animation.play("Transi_IN", -1, -1.0, true)
		GAME.from_position_scene_music = 0
	await parent.transition_animation.animation_finished		
	GAME.goto_scene("res://Scenes/LevelSelectionMenu/level_selection_menu.tscn")
