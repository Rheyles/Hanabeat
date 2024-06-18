extends Node2D

@onready var shapeCast : ShapeCast2D = $ShapeCast2D
@onready var area2D : Area2D = $Area2D

var linePointRef : int

var booltest : bool = true

func _ready():
	_renameAtInstantiate()
	_checkForOtherFuseNode()

func _process(delta):
	if booltest:
		_checkForOtherFuseNode()
		booltest = false

func _renameAtInstantiate():
	self.name = "FuseNode_" + str(linePointRef)

func _checkForOtherFuseNode():
#At instantiate => Check for colision with other FuseNode Collider ? Instance "knot sprite" for visual fb ?
#At each step of burning => Check for colision with other FuseNode Collider, if it return a FuseNode, burn every Node returned.
	#shapeCast.enabled = true
	#print(shapeCast.is_colliding())
	#if shapeCast.is_colliding():
		#var i = shapeCast.get_collision_count()
		#while i > 0:
			#var colliderFuseNode = shapeCast.get_collider(i-1).get_parent()
			#print(colliderFuseNode.name)
			#colliderFuseNode.get_node("Sprite2D").modulate = Color.GREEN_YELLOW
			#
			#i -= 1
	#
	#shapeCast.enabled = false
	print(area2D.has_overlapping_areas())
	if area2D.has_overlapping_areas():
		var i = area2D.get_overlapping_areas().size()
		var areas = area2D.get_overlapping_areas()
		while i > 0:
			var colliderFuseNode = areas[i-1].get_parent()
			print(colliderFuseNode.name)
			colliderFuseNode.get_node("Sprite2D").modulate = Color.GREEN_YELLOW
			
			i -= 1
