extends Node2D

@export var rocket_sound : Resource
@export var launch_sound : Resource

var rocket_id = 0
var rocket_start_time = 0

@onready var fuse = $Fuse_Scene

@onready var flame_sprite = $Sprites/Flame
@onready var rocket_sprite = $Sprites/RocketHolder/Rocket
@onready var rocket_animation = $Sprites/RocketHolder/AnimationPlayer
@onready var sound_player = $AudioStreamPlayer

signal rocket_start(id,time)

### BUILT-IN
# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	
	rocket_animation.play("idle")
	rocket_animation.animation_finished.connect(_on_RocketAnimation_animation_finished)
	flame_sprite.visible = false
	flame_sprite.animation_finished.connect(_on_Flame_animation_finished)
	
	fuse.fuse_idx = rocket_id
	fuse.first_node.burnt.connect(_on_Fuse_burnt)
	
	randomize()
	rocket_sprite.material.set_shader_parameter("replaceGreen",Color.from_hsv(randf(),1.0,0.8))
	randomize()
	rocket_sprite.material.set_shader_parameter("replaceRed",Color.from_hsv(randf(),1.0,0.61))
	randomize()
	rocket_sprite.material.set_shader_parameter("replaceBlue",Color.from_hsv(randf(),0.0,1.0))

	get_parent().connect_rocket(self)


### LOGIC



### SIGNAL RESPONSES

func _on_Fuse_burnt(_fuse_idx:int, _line_point_ref:int) -> void:
	#rocket_start_time = Time.get_ticks_msec()
	rocket_start_time = Engine.get_process_frames()
	emit_signal("rocket_start",rocket_id,rocket_start_time)
	rocket_animation.play("Starting")
	sound_player.stream = rocket_sound
	sound_player.play()
	
func _on_RocketAnimation_animation_finished(anim_name:String) -> void:
	if anim_name == "Starting":
		flame_sprite.visible = true
		flame_sprite.play("Starting")


func _on_Flame_animation_finished() -> void:
	if flame_sprite.animation == "Starting":
		flame_sprite.play("Going")
		rocket_animation.play("going")
		sound_player.stream = launch_sound
		sound_player.play()

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if not new_value:
		rocket_animation.play("RESET")
		await rocket_animation.animation_finished
		rocket_animation.play("idle")
		flame_sprite.stop()
		flame_sprite.visible = false
		$Sprites.position = Vector2.ZERO
		rocket_start_time = 0
		sound_player.stop()
