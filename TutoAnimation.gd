extends Node2D

@onready var frame = get_node("Sprite2D").frame
@onready var sprite = get_node("Sprite2D")

func _ready():
	_next_frame()

func _next_frame():
	if frame < 64:
		frame += 1
		sprite.set_frame(frame)
	else:
		frame = 0
		sprite.set_frame(frame)
	wait(0.1)
	print(frame)

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	_next_frame()
