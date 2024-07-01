extends Node2D

const fuse_scene = preload("res://Scenes/Playground/Fuse/Fuse.tscn")

@export_range (1, 8) var fuses_nb :int = 4
var margin_x : float = 80.0
var margin_y : float = 45.0

var fuses = []
var rocket_start = []


### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	var fuse_origin = - ((fuses_nb - 1) * margin_x) / 2
	for i in range(fuses_nb):
		var newFuse = fuse_scene.instantiate()
		add_child(newFuse)
		newFuse.position.x = fuse_origin + (i * margin_x)
		newFuse.position.y = margin_y
		newFuse.fuse_idx = i
		rocket_start.append(0)
		newFuse.first_node.burnt.connect(_on_Fuse_burnt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

### LOGIC



### SIGNAL RESPONSES

func _on_Fuse_burnt(fuse_idx:int, line_point_ref:int) -> void:
	rocket_start[fuse_idx] = Time.get_ticks_msec()
	print(rocket_start)
