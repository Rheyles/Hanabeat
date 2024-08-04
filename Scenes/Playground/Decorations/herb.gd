extends Sprite2D


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomize()
	var offset_val = rng.randf_range(0.0,0.5)
	self.material.set_shader_parameter("Offset", offset_val)

