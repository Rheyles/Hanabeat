extends Node2D

@export var fuse_scene : Resource

@export_range (1, 8) var fuses_nb :int = 4
var margin_x : float = 80.0
var margin_y : float = 45.0

var rocket_id = 0

var fuses = []
var rocket_start_time = []

@onready var flame_sprite = $Sprites/Flame
@onready var rocket_sprite = $Sprites/RocketHolder/Rocket
@onready var rocket_animation = $Sprites/RocketHolder/AnimationPlayer

signal rocket_start(id,time)

### BUILT-IN
# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	
	rocket_animation.play("idle")
	rocket_animation.animation_finished.connect(_on_RocketAnimation_animation_finished)
	flame_sprite.visible = false
	flame_sprite.animation_finished.connect(_on_Flame_animation_finished)
	
	var fuse_origin = - ((fuses_nb - 1) * margin_x) / 2
	for i in range(fuses_nb):
		var newFuse = fuse_scene.instantiate()
		add_child(newFuse)
		newFuse.position.x = fuse_origin + (i * margin_x)
		newFuse.position.y = margin_y
		newFuse.fuse_idx = i
		rocket_start_time.append(0)
		newFuse.first_node.burnt.connect(_on_Fuse_burnt)
	
	#get_parent().connect_rocket(self)


### LOGIC



### SIGNAL RESPONSES

func _on_Fuse_burnt(_fuse_idx:int, _line_point_ref:int) -> void:
	rocket_start_time = Time.get_ticks_msec()
	emit_signal("rocket_start",rocket_id,rocket_start_time)
	rocket_animation.play("Starting")
	
func _on_RocketAnimation_animation_finished(anim_name:String) -> void:
	if anim_name == "Starting":
		flame_sprite.visible = true
		flame_sprite.play("Starting")


func _on_Flame_animation_finished() -> void:
	if flame_sprite.animation == "Starting":
		flame_sprite.play("Going")
		rocket_animation.play("going")

func _on_EVENTS_has_detonated(_new_value:bool)->void:
	rocket_animation.play("idle")
	flame_sprite.stop()
	flame_sprite.visible = false
	$Sprites.position = Vector2.ZERO
	rocket_start_time = 0
