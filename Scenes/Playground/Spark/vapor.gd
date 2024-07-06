extends Node2D

@export var big : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("vapor")
	if big:
		$AudioStreamPlayer.play()

