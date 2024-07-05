extends Area2D

@export var is_water : bool = true
@export var oil_modulate : Color

@onready var shape_cast = $ShapeCast2D

func _ready():
	self.area_entered.connect(_on_area_entered)
	if is_water:
		modulate = Color.WHITE
	else:
		modulate = oil_modulate

func _on_area_entered(area:Area2D)->void:
	if is_water:
		if area is Spark:
			area.destroy()
	else:
		shape_cast.force_shapecast_update()
		var i = shape_cast.get_collision_count()
		while i > 0:
			var collider_fuse_node = shape_cast.get_collider(i-1).get_parent()
			if not collider_fuse_node.is_burnt :
				collider_fuse_node.call_deferred('_burn')
			i -= 1
