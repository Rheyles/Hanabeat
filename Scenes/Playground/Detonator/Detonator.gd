extends Node2D

const spark_scene = preload("res://Scenes/Playground/Spark/Spark.tscn")

@onready var spark_spawn = $SparkSpawn
@onready var click_area = $ClickArea

@onready var tail_sprite = $Tail
@onready var dragon_sprite = $Dragon
@onready var dragon_anim_sprite = $Dragon/AnimationPlayer
@onready var flame_sprite = $FlameSprite

var mouse_is_in : bool = false
var is_ignite : bool = false

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	click_area.mouse_entered.connect(_on_ClickArea_mouse_entered)
	click_area.mouse_exited.connect(_on_ClickArea_mouse_exited)
	tail_sprite.animation_finished.connect(_on_Tail_animation_finished)
	
	flame_sprite.frame = 9
	dragon_anim_sprite.play("Idle")
	tail_sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('left_click') and mouse_is_in:
		# If there is mouse click on the detonator, we create a spark
		create_spark()
		flame_sprite.stop()
		dragon_anim_sprite.stop()
		flame_sprite.play("default")
		dragon_anim_sprite.play("Idle")

### LOGIC

func create_spark() -> void:
	# Create a spark at the spawn
	var newSpark = spark_scene.instantiate()
	get_parent().add_child(newSpark)
	newSpark.global_position = spark_spawn.global_position

### SIGNAL RESPONSES

func _on_ClickArea_mouse_entered() -> void:
	mouse_is_in = true
	#get_node("DetonatorSprite").frame = 1

func _on_ClickArea_mouse_exited() -> void:
	mouse_is_in = false
	#get_node("DetonatorSprite").frame = 0

func _on_Tail_animation_finished() -> void:
	await get_tree().create_timer(randi_range(0,3)).timeout
	tail_sprite.play("default")
