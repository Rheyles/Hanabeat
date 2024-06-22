extends Node2D

const spark_scene = preload("res://Scenes/Spark/Spark.tscn")

@onready var spark_spawn = $SparkSpawn
@onready var click_area = $ClickArea

var mouse_is_in : bool = false
var is_ignite : bool = false

var connected_fuses = []

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	click_area.mouse_entered.connect(_on_ClickArea_mouse_entered)
	click_area.mouse_exited.connect(_on_ClickArea_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('click') and mouse_is_in:
		# If there is mouse click on the detonator, we create a spark
		create_spark()
		get_node("FlameSprite").visible = true

### LOGIC

func create_spark() -> void:
	# Create a spark at the spawn
	for i in range(len(connected_fuses)):
		connected_fuses[i].igniteFuse()
	connected_fuses.clear()
	pass
	

func connect_new_fuse(newFuse : Node2D):
	connected_fuses.append(newFuse)
	print(connected_fuses)

### SIGNAL RESPONSES

func _on_ClickArea_mouse_entered() -> void:
	mouse_is_in = true
	get_node("DetonatorSprite").frame = 1

func _on_ClickArea_mouse_exited() -> void:
	mouse_is_in = false
	get_node("DetonatorSprite").frame = 0
