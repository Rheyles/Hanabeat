extends Node2D
class_name FuseNode

@export var spark_scene : Resource
@export var fuse_not_burnt_sprite = Resource
@export var fuse_burnt_sprite = Resource
@export var firstfuse_not_burnt_sprite = Resource
@export var firstfuse_burnt_sprite = Resource

@onready var area2D = $Area2D
@onready var fuse_sprite = $fuseSprite

var parent_fuse_ref
var fuseNode_idx : int #Index in the FuseNode List => Order of FuseNode

var mouse_is_in : bool = false

var is_burnt : bool = false

signal burnt(fuse_idx, fuseNode_idx)

### BUILT-IN

func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	area2D.mouse_entered.connect(_on_ClickArea_mouse_entered)
	area2D.mouse_exited.connect(_on_ClickArea_mouse_exited)
	_renameAtInstantiate()

### LOGIC

func _renameAtInstantiate():
	self.name = "FuseNode_" + str(fuseNode_idx)

func _burn():
	is_burnt = true
	fuse_sprite.texture = fuse_burnt_sprite
	if fuseNode_idx == 0:
		fuse_sprite.texture = firstfuse_burnt_sprite
	emit_signal("burnt", parent_fuse_ref.fuse_idx, fuseNode_idx)
	start_new_burn_point()
#Visual
	var node_gradient = fuse_sprite.self_modulate.g
	fuse_sprite.self_modulate = Color(node_gradient,node_gradient,node_gradient)
	get_node("Sprite2D").modulate = Color.FIREBRICK

func start_new_burn_point():
	parent_fuse_ref.is_burning = true
	var newSpark = spark_scene.instantiate()
	get_parent().add_child(newSpark)
	newSpark.position = self.position
	#print("new burn on FuseNode n° : " + str(fuseNode_idx))

### SIGNAL RESPONSES

func _on_ClickArea_mouse_entered() -> void:
	mouse_is_in = true
	if parent_fuse_ref != null:
		get_tree().current_scene.get_node("%MouseController").hovered_fuse = parent_fuse_ref
	if fuseNode_idx == parent_fuse_ref.fuseNode_list.size()-1:
		get_tree().current_scene.get_node("%MouseController").mouse_is_on_last_fuseNode = true
		get_tree().current_scene.get_node("%MouseController").last_node_pos = global_position

func _on_ClickArea_mouse_exited() -> void:
	mouse_is_in = false
	if get_tree().current_scene.get_node("%MouseController").pressed == false:
		get_tree().current_scene.get_node("%MouseController").mouse_is_on_last_fuseNode = false

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if not new_value :
		is_burnt = false
		fuse_sprite.texture = fuse_not_burnt_sprite
		if fuseNode_idx == 0:
			fuse_sprite.texture = firstfuse_not_burnt_sprite
