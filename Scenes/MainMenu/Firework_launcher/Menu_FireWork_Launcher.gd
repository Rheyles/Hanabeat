extends Node2D

@export var firework_shell_scene : Resource

var launch_timer : float = 1.5
var launch_pos_list = [Vector2(128,706),Vector2(311,640),Vector2(470,710)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if launch_timer <= 0:
		for i in range(len(launch_pos_list)):
			var newShell = firework_shell_scene.instantiate()
			newShell.position = launch_pos_list[i]
			add_child(newShell)
			launch_timer = 3
	launch_timer -= 1*delta
