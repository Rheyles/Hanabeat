extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	### TEMP
	get_parent().get_parent().get_parent().firework_animation.play("fly_in",-1,-1.0,true)
	await get_parent().get_parent().get_parent().firework_animation.animation_finished
	get_parent().get_parent().get_parent().firework_visualizer.visible = false
