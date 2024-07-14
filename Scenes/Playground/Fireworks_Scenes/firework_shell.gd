extends Node2D

@export var fireWorkExplosion: Resource

var timer_is_random : bool = true
var timer: float = 1.4 #Delay Before explosion
var fireworks_scale_is_random : bool = false
var fireworks_scale_range_max : float = 1
var fireworks_scale_range_min : float = 1
var speed: float = 450 #movespeed during delay
var fireworks_light : bool

var colors = [Color(0, 0.706, 0.765),Color(0.964, 0.903, 0),Color(0.987, 0.366, 0.636), Color(0.094, 0.678, 0.522), Color(0.745, 0.855, 1), Color(0.873, 0.537, 0.447)] #Turquoise / Jaune / Rose / Vert / AlmostWhite / Automne Color Preset to pick from

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if timer_is_random:
		timer = rng.randfn(1,0.2)
	get_node("PointLight2D").visible = fireworks_light

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer > 0:
		self.move_local_y(-speed * delta,false)
		timer -= 1*delta
		
	if timer <= 0:
		var newExplosion = fireWorkExplosion.instantiate()
		add_child(newExplosion)
		newExplosion.reparent(get_node(".."))
		
		newExplosion.global_position = self.global_position
		var NewColor = colors[randi() % colors.size()]
		if fireworks_scale_is_random:
			var NewScale = randf_range(fireworks_scale_range_min, fireworks_scale_range_max)
			newExplosion.scale = Vector2(NewScale,NewScale)
		else:
			newExplosion.scale = Vector2(fireworks_scale_range_max,fireworks_scale_range_max)
		newExplosion.get_node("PointLight2D").visible = fireworks_light
		newExplosion.get_node("GPUParticles2D").process_material.color = NewColor
		newExplosion.get_node("PointLight2D").color = NewColor
		newExplosion.get_node("GPUParticles2D").emitting = true
		
		queue_free()

