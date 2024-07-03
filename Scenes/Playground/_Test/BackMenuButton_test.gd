extends TextureButton

@export var main_menu_scene : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(_on_button_down)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_down()->void:
	GAME.goto_scene("res://Scenes/MainMenu/MainMenu.tscn")
