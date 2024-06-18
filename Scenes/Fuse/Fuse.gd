extends Node2D

@export var firework : Resource
@export var fuseFire : Resource
@export var spark : Resource

var startingPos : Vector2

func _eraseLine(lineToErase: Line2D):
#Fonction qui va suppr la line2D point par point avec un delay entre chaque boucle
#A la fin call une instance de FireWork
	var newSpark = spark.instantiate()
	newSpark.actualFuseNodePos = lineToErase.get_point_position(lineToErase.get_point_count()-1)
	newSpark.position = newSpark.actualFuseNodePos
	newSpark.fuseRef = self
	add_child(newSpark)
	newSpark._burnTheFuse()

func _lunchFirework():
	var newFirework = firework.instantiate()
	newFirework.position = startingPos
	add_child(newFirework)
	newFirework.reparent(get_node(".."))
	print("Line erased")
	queue_free()
