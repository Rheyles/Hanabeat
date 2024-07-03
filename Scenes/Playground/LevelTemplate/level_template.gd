extends Node2D

var rockets = []
var rockets_times = []

### BUILT-IN
# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)

### LOGIC

func connect_rocket(rocket) -> void:
	rocket.rocket_id = len(rockets)
	rockets.append(rocket)
	rockets_times.append(0)
	rocket.rocket_start.connect(_on_Rocket_rocket_start)

### SIGNAL RESPONSES

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if new_value:
		pass
	else:
		for time in rockets_times:
			time = 0

func _on_Rocket_rocket_start(id,time)->void:
	rockets_times[id] = time
	print(rockets_times)
	
	if 0 in rockets_times:
		pass
	else:
		var score = rockets_times.max() - rockets_times.min()
		print("Your score : " + str(score))
		if score < GAME.WIN_MARGIN * 100:
			print("You won !")
		else:
			print("It didn\'t work... Try again !")
