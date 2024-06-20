extends Node2D

@export var firework : Resource
@export var spark : Resource

var fuse_idx : int
var first_node
var is_burning : bool = false

var starting_pos : Vector2

### LOGIC

#ANCIENNE LOGIC A SPRR CAR C EST LE ROCKETBANK QUI DOIT AVOIR CETTE LOGIC
func _lunchFirework():
	var newFirework = firework.instantiate()
	newFirework.position = starting_pos
	add_child(newFirework)
	newFirework.reparent(get_node(".."))
	print("Line erased")
	queue_free()

#ANCIENNE LOGIC A SPRR CAR C EST LE DETONATOR QUI DOIT AVOIR CETTE LOGIC
func _eraseLine():
#Fonction qui va suppr la line2D point par point avec un delay entre chaque boucle
#A la fin call une instance de FireWork
	is_burning = true
	get_child(get_node("Line2D").get_point_count())._start_new_burn_point()
	print(get_node("Line2D").get_point_count())
	print(get_child(get_node("Line2D").get_point_count()).name)
