extends Node2D

@onready var fuse_1 = $Fuse1
@onready var fuse_2 = $Fuse2
@onready var fuse_3 = $Fuse3
@onready var fuse_4 = $Fuse4

var fuses = [fuse_1, fuse_2, fuse_3, fuse_4]
var rocket_start = [0,0,0,0]


### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	fuses = [fuse_1, fuse_2, fuse_3, fuse_4]
	for i in range(len(fuses)):
		fuses[i].fuse_idx = i
		#fuses[i].first_node.burnt.connect(_on_Fuse_burnt)
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

### LOGIC



### SIGNAL RESPONSES

func _on_Fuse_burnt(fuse_idx:int) -> void:
	rocket_start[fuse_idx] = Time.get_ticks_msec()
	print(rocket_start)
