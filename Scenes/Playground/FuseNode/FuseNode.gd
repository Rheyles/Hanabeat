extends Node2D
class_name FuseNode

@export var spark_scene : Resource
@export var fuse_not_burnt_sprite = Resource
@export var fuse_burnt_sprite = Resource
@export var firstfuse_not_burnt_sprite = Resource
@export var firstfuse_burnt_sprite = Resource

@onready var click_area = $ClickArea
@onready var fuse_sprite = $fuseSprite
@onready var flash_player = $FlashPlayer

var flash_on : bool = false

var parent_fuse_ref
var fuseNode_idx : int #Index in the FuseNode List => Order of FuseNode

var mouse_is_in : bool = false

var is_burnt : bool = false

signal burnt(fuse_idx, fuseNode_idx)

### BUILT-IN

func _ready():
	EVENTS.emit_signal("fuse_node_nb_changed", 1)
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	click_area.mouse_entered.connect(_on_ClickArea_mouse_entered)
	click_area.mouse_exited.connect(_on_ClickArea_mouse_exited)
	flash_player.animation_finished.connect(_on_FlashPlayer_animation_finished)
	_renameAtInstantiate()

### LOGIC
	
func destroy():
	EVENTS.emit_signal("fuse_node_nb_changed", -1)
	queue_free()

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
	get_node("Sprite2D").visible = false

func start_new_burn_point():
	parent_fuse_ref.is_burning = true
	var newSpark = spark_scene.instantiate()
	get_parent().add_child(newSpark)
	newSpark.position = self.position
	#print("new burn on FuseNode n° : " + str(fuseNode_idx))

func display_flash_color():
	if not flash_on:
		flash_player.play("flash")

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

func _on_FlashPlayer_animation_finished(_anim):
	flash_on = false
