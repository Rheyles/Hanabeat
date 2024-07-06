extends AnimatedSprite2D

@export var default_shader_scale = 0.85
var tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	set_shader_value(default_shader_scale)

# tween value automatically gets passed into this function
func set_shader_value(value: float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	self.material.set_shader_parameter("SCALE", value);

func _on_EVENTS_has_detonated(new_value:bool)->void:
	tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	var scale_target = default_shader_scale - float(new_value) * 0.35
	# args are: (method to call / start value / end value / duration of animation)
	tween.tween_method(set_shader_value, self.material.get_shader_parameter("SCALE"), scale_target, 1.0)
