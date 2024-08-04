extends Control

@export var dialog_box_scene : Resource
@export var character_sprite_list  = []

@onready var animationPlayer = $AnimationPlayer
@onready var characterSprite = $Node2D/character

signal dialog_end(level_number)

var dialog_pos : Vector2
var lvl_number : int

var dialog_index : int = 0
var dialog_length : int = 0
var dialog_animation_stoped : bool = false

var last_box

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog_pos = get_node("Node2D/DialoguePos").global_position

func _process(_delta):
	if Input.is_action_just_pressed("left_click") && dialog_animation_stoped:
		if dialog_index >= dialog_length - 1:
			emit_signal("dialog_end",lvl_number)
		else:
			dialog_index += 1
			trigger_next_dialog()

func create_pop_up_dialog(text:String, pos:Vector2)->void:
	var new_box = dialog_box_scene.instantiate()
	new_box.z_index = 7
	add_child(new_box)
	last_box = new_box
	new_box.display_text(text, pos)
	dialog_animation_stoped = true

func trigger_dialog(lvlNb : int):
	lvl_number = lvlNb
	dialog_index = 0
	dialog_length = LEVELS.level_dict[lvl_number].size()
	print(LEVELS.level_dict[lvl_number].size())
	characterSprite.texture = character_sprite_list[LEVELS.level_dict[lvl_number][0]]
	animationPlayer.play("Starting")
	visible = true
	await animationPlayer.animation_finished
	animationPlayer.queue("Idle")
	create_pop_up_dialog(tr("LVL_INTRO_" + str(lvl_number) +"_"+ str(dialog_index)), dialog_pos)

func trigger_next_dialog():
	last_box.queue_free()
	characterSprite.texture = character_sprite_list[LEVELS.level_dict[lvl_number][dialog_index]]
	create_pop_up_dialog(tr("LVL_INTRO_" + str(lvl_number)+"_" + str(dialog_index)), dialog_pos)
