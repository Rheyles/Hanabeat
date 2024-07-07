extends Node2D

@onready var timer = $Timer

@export var firework_shell_scene : Resource

@export var launch_timer : float = 1.4
@export var x_offset_range : int = 50
@export var angle_offset_range : int = 15
@export var shell_speed : int = 450
@export var shell_delay_is_random : bool = true
@export var shell_delay : float = 1.4
@export var fireworks_scale_is_random : bool = false
@export var fireworks_scale_range_min : float = 1
@export var fireworks_scale_range_max : float = 1
@export var fireworks_light : bool = true


func _ready():
	timer.timeout.connect(_on_Timer_timeout)
	timer.start(launch_timer)

func _on_Timer_timeout()->void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var newShell = firework_shell_scene.instantiate()
	newShell.position.y = 0
	newShell.position.x = rng.randf_range(-x_offset_range,x_offset_range)
	newShell.rotation = deg_to_rad(randf_range(-angle_offset_range,angle_offset_range))
	newShell.speed = shell_speed
	newShell.timer = shell_delay
	newShell.timer_is_random = shell_delay_is_random
	newShell.fireworks_scale_is_random = fireworks_scale_is_random
	newShell.fireworks_scale_range_max = fireworks_scale_range_max
	newShell.fireworks_scale_range_min = fireworks_scale_range_min
	newShell.fireworks_light = fireworks_light
	add_child(newShell)
	timer.start(launch_timer + rng.randf_range(-launch_timer,0.5 * launch_timer))
