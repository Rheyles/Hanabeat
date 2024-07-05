extends Node

## GAME
## This autoload contains all the method and variable used along the game
var WIN_MARGIN : float = 5.0

var MIN_NODE_DIST : float = 10

var button_clicked = false

var has_detonated:bool = false : set=set_has_detonated
### ACCESSORS ###
func set_has_detonated(new_value:bool) -> void:
	has_detonated = new_value
	EVENTS.emit_signal("has_detonated", new_value)
	

### BUILT-IN
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)


### LOGIC

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.

	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()

	# Load new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
