extends Control

@export var dialog_box_scene : Resource

@onready var animationPlayer = $AnimationPlayer

signal dialog_end(level_number)

var dialog_pos : Vector2
var lvl_number : int

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog_pos = get_node("Node2D/DialoguePos").global_position

func create_pop_up_dialog(text:String, pos:Vector2)->void:
	var new_box = dialog_box_scene.instantiate()
	new_box.z_index = 7
	add_child(new_box)
	new_box.display_text(text, pos)

func trigger_dialog(lvlNb : int):
	lvl_number = lvlNb
	animationPlayer.play("Starting")
	visible = true
	await animationPlayer.animation_finished
	animationPlayer.queue("Idle")
	create_pop_up_dialog("Hello World, I'm Bīan pào (I think). And I still don't know for sure what's this game is ?!", dialog_pos)


func _on_button_button_down():
	emit_signal("dialog_end",lvl_number)
