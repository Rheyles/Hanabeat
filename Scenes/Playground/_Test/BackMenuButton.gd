extends TextureButton

@onready var back_to_menu_scene = $"../Back_To_Menu"

### BUILT-IN

func _ready():
	button_down.connect(_on_button_down)
	back_to_menu_scene.visible = false


### SIGNAL RESPONSES

func _on_button_down():
	back_to_menu_scene.set_message("Leave the level ?")
	back_to_menu_scene.visible = true
