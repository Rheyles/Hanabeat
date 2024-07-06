extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	### TEMP
	var parent = get_parent().get_parent().get_parent()
	parent.firework_animation.play("fly_in",-1,-1.0,true)
	await parent.firework_animation.animation_finished
	parent.firework_visualizer.visible = false
	parent.transition.visible = true
	parent.transition_animation.play("Transi_IN",-1,1.0)
