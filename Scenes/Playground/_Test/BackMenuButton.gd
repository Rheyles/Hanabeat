extends TextureButton

@onready var back_to_menu_scene = $"../Back_To_Menu"

### SIGNAL RESPONSES

func _on_button_down():
	back_to_menu_scene.visible = true
