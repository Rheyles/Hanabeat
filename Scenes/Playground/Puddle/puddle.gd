extends Area2D

@export var is_water : bool = true
@export var oil_modulate : Color
@export var vapor_scene : Resource

@onready var shape_cast = $ShapeCast2D

var fuse_nodes_inside = []

func _ready():
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)
	
	if is_water:
		modulate = Color.WHITE
	else:
		modulate = oil_modulate

func _on_area_entered(area:Area2D)->void:
	if not area is Spark:
		fuse_nodes_inside.append(area.get_parent())
	
	if is_water:
		if area is Spark:
			var vapor = vapor_scene.instantiate()
			vapor.global_position = area.global_position
			GAME.current_scene.get_node("%MouseController").add_child(vapor)
			area.destroy()
	else:
		if area is Spark:
			$FlameParticles.emitting = true
			$AnimationPlayer.play("blink")
			for node in fuse_nodes_inside:
				if not node.is_burnt :
					node.call_deferred('_burn')
			#shape_cast.force_shapecast_update()
			#var i = shape_cast.get_collision_count()
			#while i > 0:
				#var collider_fuse_node = shape_cast.get_collider(i-1).get_parent()
				#if not collider_fuse_node.is_burnt :
					#collider_fuse_node.call_deferred('_burn')
				#i -= 1

func _on_area_exited(area:Area2D)->void:
	fuse_nodes_inside.erase(area.get_parent())

