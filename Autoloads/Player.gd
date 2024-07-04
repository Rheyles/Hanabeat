extends Node

## PLAYER
## This autoload contains all the method and variable used to manage player data

const player_file_path = "user://player_data.json"

var default_data : Dictionary = {}
var current_data : Dictionary = {}

func _ready() -> void:
	var score_by_level: Array = []
	for _i in range(LEVELS.levels.size()):
		score_by_level.append(-1)
	
	default_data['lng'] = "en"
	default_data['score_by_level'] = score_by_level
	
	reset_data()
	
	if FileAccess.file_exists(player_file_path) :
		load_data(player_file_path)
		align_data()
		save_data(player_file_path)
	else:
		save_data(player_file_path)
	
	LOCAL.change_lng(current_data['lng'])
	
	EVENTS.save_player_data.connect(_on_EVENTS_save_player_data)

func reset_data():
	current_data['lng'] = default_data['lng']
	current_data['score_by_level'] = default_data['score_by_level']


func save_data(path: String) -> void:
	current_data['lng'] = TranslationServer.get_locale()
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(JSON.stringify(current_data))
	file.close()


func load_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	
	var data_json = JSON.parse_string(file.get_as_text())
	file.close()
	current_data = data_json
	
	LOCAL.change_lng(current_data['lng'])


func align_data() -> void:
	for key in default_data.keys():
		if not current_data.has(key) :
			current_data[key] = default_data[key]
	
	for _i in range(default_data['score_by_level'].size()- current_data['score_by_level'].size()):
		current_data['score_by_level'].append(-1)


func _on_EVENTS_save_player_data() -> void:
	save_data(player_file_path)
