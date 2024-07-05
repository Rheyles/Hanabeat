extends Node2D

@onready var timer = $Timer

@export var firework_shell_scene : Resource

var launch_timer : float = 1.4
var launch_pos_list = [Vector2(217,560),Vector2(296,545),Vector2(344,615)]

func _ready():
	timer.timeout.connect(_on_Timer_timeout)
	timer.start(launch_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if launch_timer <= 0:
		#for i in range(len(launch_pos_list)):
			##await get_tree().create_timer(randf_range(0.0,0.1)).timeout
			#var newShell = firework_shell_scene.instantiate()
			#newShell.position = launch_pos_list[i]
			##newShell.rotation_degrees = newShell.rotation_degrees + randf_range(-20,20)
			#add_child(newShell)
		#launch_timer = 3
	#launch_timer -= 1*delta

func _on_Timer_timeout()->void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var newShell = firework_shell_scene.instantiate()
	newShell.position.y = 0
	newShell.position.x = rng.randf_range(-100,100)
	#newShell.rotation = newShell.rotation + rng.randf_range(-20,20)
	add_child(newShell)
	timer.start(launch_timer + rng.randf_range(-launch_timer,0.5 * launch_timer))
