extends Node2D

var timer: float = 0.8
var speed: float = 190
@export var fireWorkExplosion: Resource

var colors = [Color(0, 0.706, 0.765),Color(0.964, 0.903, 0),Color(0.987, 0.366, 0.636)] #Turquoise / Jaune / Rose

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer > 0:
		position += Vector2.UP * speed * delta
		timer -= 1*delta
	if timer <= 0:
		var newExplosion = fireWorkExplosion.instantiate()
		add_child(newExplosion)
		newExplosion.reparent(get_node(".."))
		
		newExplosion.global_position = self.global_position
		newExplosion.get_node("GPUParticles2D").process_material.color = colors[randi() % colors.size()]
		newExplosion.get_node("GPUParticles2D").emitting = true
		
		queue_free()
