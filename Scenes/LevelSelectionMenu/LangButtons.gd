extends Control

@onready var fr_button = $HBoxContainer/Fr
@onready var en_button = $HBoxContainer/En

@onready var outline = $Outline

var update_once : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	fr_button.pressed.connect(_on_fr_pressed)
	en_button.pressed.connect(_on_en_pressed)
	update_display()

func _process(_delta):
	if update_once:
		update_display()
		update_once = false

func change_lng(lng_idx : int) -> void:
	LOCAL.change_lng_idx(lng_idx)
	update_display()
	EVENTS.emit_signal("save_player_data")

func update_display() -> void:
	var current_lng = TranslationServer.get_locale()
	if current_lng == "fr":
		outline.position = fr_button.position
	elif current_lng == "en":
		outline.position = en_button.position
	else :
		print("Unrecognized localization")

func _on_fr_pressed():
	change_lng(0)

func _on_en_pressed():
	change_lng(1)
