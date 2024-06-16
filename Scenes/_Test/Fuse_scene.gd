extends Node2D

@export var firework : Resource
@export var fuseFire : Resource

var erasePointDelay : float = 0.05 #Delay entre deux call d'effacement de point => Moins de delay = combustion plus rapide
var startingPos : Vector2

func eraseLine(lineToErase: Line2D):
#Fonction qui va suppr la line2D point par point avec un delay entre chaque boucle
#A la fin call une instance de FireWork
	var newFuseFire = fuseFire.instantiate()
	add_child(newFuseFire)
	while lineToErase.get_point_count() > 0:
		newFuseFire.position = lineToErase.get_point_position(lineToErase.get_point_count()-1)
		await get_tree().create_timer(erasePointDelay).timeout
		lineToErase.remove_point(lineToErase.get_point_count()-1)
	newFuseFire.queue_free()
	var newFirework = firework.instantiate()
	newFirework.position = startingPos
	add_child(newFirework)
	newFirework.reparent(get_node(".."))
	print("Line erased")
	queue_free()
