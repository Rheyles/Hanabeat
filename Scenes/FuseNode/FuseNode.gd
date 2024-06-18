extends Node2D

var linePointRef : int

func _renameAtInstantiate():
	self.name = "FuseNode_" + str(linePointRef)

func _checkForOtherFuseNode():
	#At instantiate => Check for colision with other FuseNode Collider ? Instance "knot sprite" for visual fb ?
	#At each step of burning => Check for colision with other FuseNode Collider, if it return a FuseNode, burn every Node returned.
	pass
