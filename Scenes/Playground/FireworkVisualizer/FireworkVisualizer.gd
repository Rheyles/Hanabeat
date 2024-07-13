extends Control

@onready var music_player = $MusicPlayer
@onready var transition_animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	music_player.finished.connect(_on_MusicPlayer_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_MusicPlayer_finished()->void:
	music_player.play()

func _music_fade_in(duration : float):
	var tween_out = create_tween()
	tween_out.tween_property(music_player,"volume_db",0,duration)
