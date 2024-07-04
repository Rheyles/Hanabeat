extends Node2D

@onready var music_player = $MusicPlayer

var rockets = []
var rockets_times = []

var last_score = -1 : set=set_last_score
var best_score = -1

### ACCESSORS

func set_last_score(new_val : int)->void:
	last_score = new_val
	if new_val < best_score or best_score==-1:
		best_score = last_score
		## TEMP pour debug
		PLAYER.current_data['score_by_level'][0] = best_score
		PLAYER.save_data(PLAYER.player_file_path)
		##

### BUILT-IN
# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.has_detonated = false
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	music_player.finished.connect(_on_MusicPlayer_finished)
	music_player.play()
	## TEMP pour debug
	PLAYER.load_data(PLAYER.player_file_path)
	best_score = PLAYER.current_data['score_by_level'][0]
	##
	update_score_display()

### LOGIC

func connect_rocket(rocket) -> void:
	rocket.rocket_id = len(rockets)
	rockets.append(rocket)
	rockets_times.append(0)
	rocket.rocket_start.connect(_on_Rocket_rocket_start)
	
func update_score_display()->void:
	$UI/Label.text = 'Best score : '
	if best_score == -1:
		$UI/Label.text += '-'
	else :
		$UI/Label.text += str(best_score)
	$UI/Label.text += '\nLast score : '
	if last_score == -1:
		$UI/Label.text += '-'
	else :
		$UI/Label.text += str(last_score)

### SIGNAL RESPONSES

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if new_value:
		pass
	else:
		for i in range(len(rockets_times)):
			rockets_times[i] = 0

func _on_MusicPlayer_finished()->void:
	music_player.play()

func _on_Rocket_rocket_start(id,time)->void:
	rockets_times[id] = time
	
	if 0 in rockets_times:
		pass
	else:
		var score = rockets_times.max() - rockets_times.min()
		set_last_score(score)
		update_score_display()
		print(rockets_times)
		print("Your score : " + str(score))
		if score < GAME.WIN_MARGIN * 100:
			print("You won !")
		else:
			print("It didn\'t work... Try again !")
