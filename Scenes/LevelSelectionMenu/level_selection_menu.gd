extends Node

@export var select_sound : Resource

@onready var animationPlayer = $AnimationPlayer
@onready var sound_player = $SoundPlayer

@onready var tuto_text1 = $"Tuto UI/TutoText"
@onready var tuto_text2 = $"Tuto UI/TutoText2"
@onready var tuto_anim = $"Tuto UI/AnimatedSprite2D"

var in_transition : bool = false

func _ready():
	sound_player.play(GAME.from_position_scene_music)
	sound_player.finished.connect(_on_SoundPlayer_finished)
	EVENTS.language_changed.connect(_on_EVENTS_language_changed)
	tuto_anim.play("new_animation")
	update_lng()

func play_sound(sound_name:String)->void:
	if not in_transition:
		if sound_name == "select":
			in_transition = true
			sound_player.stream = select_sound
			sound_player.pitch_scale = 1
		sound_player.play()

func update_lng():
	tuto_text1.text = tr("LVL_SEL_TUTO_1")
	tuto_text2.text = tr("LVL_SEL_TUTO_2")

### SIGNAL RESPONSES

func _on_back_menu_button_button_down():
#Load Lvl menu
	play_sound("select")
	animationPlayer.play("Transi_IN",-1,-1,true)
	await animationPlayer.animation_finished
	GAME.goto_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_SoundPlayer_finished():
	if not in_transition:
		sound_player.play()

func _on_EVENTS_language_changed():
	update_lng()
