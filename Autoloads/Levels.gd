extends Node

## LEVELS
## This autoload contains all the method and variable used to manage levels

var levels = ["res://Scenes/Playground/_Test/AmazingScene.tscn",
			  "res://Scenes/Levels/level_1.tscn",
			  "res://Scenes/Levels/level_2_bis.tscn",
			  "res://Scenes/Levels/level_3_bis.tscn",
			  "res://Scenes/Levels/level_4.tscn",
			  "res://Scenes/Levels/level_5.tscn",
			  "res://Scenes/Levels/level_6.tscn"]

var level_dict : Dictionary = {
	0:[0,2], 
	1:[0,2], 
	2:[0,1], 
	3:[1,0,2], 
	4:[0,2,0], 
	5:[0,2], 
	6:[0,1,2]}

#Sprite mood : 0 = Basic, 1 = Unhappy, 2 = Laughing

#var level_intro_0 = [0,1]
#var level_intro_1 = [0,1]
#var level_intro_2 = [2,0,0]
#var level_intro_3 = [1]
#var level_intro_4 = [0]
#var level_intro_5 = [2]
#var level_intro_6 = [0]
