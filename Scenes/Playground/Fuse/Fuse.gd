extends Node2D

const firework_scene = preload("res://Scenes/Playground/Fireworks_Scenes/Firework_shell.tscn")
const spark_scene = preload("res://Scenes/Playground/Spark/Spark.tscn")
const fuseNode_scene = preload("res://Scenes/Playground/FuseNode/FuseNode.tscn")

var fuse_idx : int = 0
var is_burning : bool = false

var starting_pos : Vector2
var first_node
var fuseNode_list = []

@onready var fuse_line = $Line2D

func _ready():
	_createFirstFuseNode()
	get_tree().current_scene.get_node("%MouseController").slice_fuse.connect(_on_Slice)


### LOGIC

func _createFirstFuseNode():
	var current_line = get_node("Line2D")
	current_line.set_point_position(0,starting_pos)
	var newNode = fuseNode_scene.instantiate()
	first_node = newNode
	newNode.position = current_line.get_point_position(0)
	newNode.parent_fuse_ref = self
	newNode.line_point_ref = 0
	add_child(newNode)
	fuseNode_list.append(newNode)
	
	get_tree().current_scene.get_node("%MouseController")._connectFirstFuseNode(newNode)

func resetFuse():
	for i in range(len(fuseNode_list)):
		fuseNode_list[i].queue_free()
	fuseNode_list.clear()
	_createFirstFuseNode()
	fuse_line.clear_points()
	fuse_line.add_point(Vector2.ZERO)

#ANCIENNE LOGIC A SPRR CAR C EST LE ROCKETBANK QUI DOIT AVOIR CETTE LOGIC
func lunchFirework():
	var newFirework = firework_scene.instantiate()
	newFirework.position = starting_pos
	add_child(newFirework)
	newFirework.reparent(get_node(".."))
	print("Line erased")
	queue_free()

#LOGIC call by the Detonator
func igniteFuse():
#Fonction qui va suppr la line2D point par point avec un delay entre chaque boucle
#A la fin call une instance de FireWork
	is_burning = true
	get_child(fuse_line.get_point_count()).start_new_burn_point()
	print("Burn Start : Nb of point in the Fuse = " + str(get_node("Line2D").get_point_count()))
	print("Burn Start : Last_Node = " + str(get_child(get_node("Line2D").get_point_count()).name))
	
	
### SIGNAL RESPONSES

func _on_Slice(start:Vector2, end:Vector2)->void:
	#print('slice signal received')
	var slice_vec = start - end
	var first_node_side = slice_vec.angle_to(start - first_node.global_position)
	var last_node_idx = 0
	
	for fuseNode in fuseNode_list:
		var node_angle = slice_vec.angle_to(start - fuseNode.global_position)
		if sign(node_angle) != sign(first_node_side) && \
				fuseNode.global_position.distance_to(start) + \
				   fuseNode.global_position.distance_to(end) < slice_vec.length() + 25 && \
				node_angle < 0.2 :
			last_node_idx = fuseNode.line_point_ref
			break
	
	if last_node_idx != 0 :
		for i in range(last_node_idx, len(fuseNode_list)):
			fuseNode_list[last_node_idx].queue_free()
			fuseNode_list.remove_at(last_node_idx)
			fuse_line.remove_point(last_node_idx)
