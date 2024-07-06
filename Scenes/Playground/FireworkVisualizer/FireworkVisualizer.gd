extends Control

@onready var music_player = $MusicPlayer
@onready var transition_animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	music_player.finished.connect(_on_MusicPlayer_finished)
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_MusicPlayer_finished()->void:
	music_player.play()
