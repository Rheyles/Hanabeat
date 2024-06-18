extends Node2D

const spark_scene = preload("res://Scenes/Spark/Spark.tscn")

@onready var spark_spawn = $SparkSpawn
@onready var click_area = $ClickArea

var mouse_is_in : bool = false

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

### LOGIC

func create_spark() -> void:
	# Create a spark at the spawn
	var spark = spark_scene.instantiate()
	add_child(spark)
	spark.transform = spark_spawn.transform
	return

### SIGNAL RESPONSES

func _on_ClickArea_mouse_entered() -> void:
	mouse_is_in = true

func _on_ClickArea_mouse_exited() -> void:
	mouse_is_in = false
