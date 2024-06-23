extends Node2D

@export var firework : Resource
@export var spark : Resource
@export var fuseNode : Resource

var fuse_idx : int = 0
var is_burning : bool = false

var starting_pos : Vector2
var first_node
var fuseNode_list = []

func _ready():
	_createFirstFuseNode()


### LOGIC

func _createFirstFuseNode():
	var current_line = get_node("Line2D")
	current_line.set_point_position(0,starting_pos)
	var newNode = fuseNode.instantiate()
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
	get_node("Line2D").clear_points()
	get_node("Line2D").add_point(Vector2.ZERO)

#ANCIENNE LOGIC A SPRR CAR C EST LE ROCKETBANK QUI DOIT AVOIR CETTE LOGIC
func lunchFirework():
	var newFirework = firework.instantiate()
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
	get_child(get_node("Line2D").get_point_count()).start_new_burn_point()
	print("Burn Start : Nb of point in the Fuse = " + str(get_node("Line2D").get_point_count()))
	print("Burn Start : Last_Node = " + str(get_child(get_node("Line2D").get_point_count()).name))
