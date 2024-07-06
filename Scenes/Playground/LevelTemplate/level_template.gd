extends Node2D
class_name Level

@export var lvl_id : int = 0
@export_range(0, 20000) var node_nb_max : int = 500
@export var fuse_sound : Resource
@export var dialog_box_scene : Resource

@onready var music_player = $MusicPlayer
@onready var sound_player = $SoundPlayer

@onready var firework_visualizer = $FireworkVisualizer
@onready var firework_animation = $FireworkVisualizer/AnimationPlayer
@onready var back_to_menu = $FireworkVisualizer/UI/Back_To_Menu

@onready var transition_animation = $AnimationPlayer
@onready var transition = $Visuals/Animation

@onready var fuse_left_gauge = $UI/FuseLeftGauge/ProgressBar
@onready var fuse_left_gauge_anim = $UI/FuseLeftGauge/AnimationPlayer

var detonator_dialog_pos = Vector2.ZERO

var rockets = []
var rockets_times = []

var last_score = -1 : set=set_last_score
var best_score = -1

var nb_spark:int = 0

### ACCESSORS

func set_last_score(new_val : int)->void:
	last_score = new_val
	if new_val < best_score or best_score==-1:
		best_score = last_score
		## TEMP pour debug
		PLAYER.current_data['score_by_level'][lvl_id] = best_score
		PLAYER.save_data(PLAYER.player_file_path)
		##


### BUILT-IN
# Called when the node enters the scene tree for the first time.
func _ready():
	firework_visualizer.visible = false
	
	GAME.has_detonated = false
	EVENTS.has_detonated.connect(_on_EVENTS_has_detonated)
	EVENTS.spark_nb_changed.connect(_on_EVENTS_spark_nb_changed)
	EVENTS.fuse_node_nb_changed.connect(_on_EVENTS_fuse_node_nb_changed)
	EVENTS.play_pop_up_dialog.connect(_on_EVENTS_play_pop_up_dialog)
	sound_player.finished.connect(_on_SoundPlayer_finished)
	music_player.finished.connect(_on_MusicPlayer_finished)
	music_player.play()
	## TEMP pour debug
	PLAYER.load_data(PLAYER.player_file_path)
	best_score = PLAYER.current_data['score_by_level'][lvl_id]
	##
	update_score_display()
	transition_animation.play("Transi_IN", -1, 1.0)
	
	fuse_left_gauge.min_value = 0
	fuse_left_gauge.max_value = node_nb_max
	fuse_left_gauge.set_value_no_signal(node_nb_max - get_node("%MouseController").nb_fuse_nodes)
	
	detonator_dialog_pos = $Detonator.global_position
	detonator_dialog_pos.y -= 50.0
	create_pop_up_dialog('C\'est parti mon kiki kiki kiki kiki kiki kiki kiki kiki kiki kiki kiki !',detonator_dialog_pos)

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

func create_pop_up_dialog(text:String, pos:Vector2)->void:
	var new_box = dialog_box_scene.instantiate()
	add_child(new_box)
	new_box.display_text(text, pos)

### SIGNAL RESPONSES

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if new_value:
		pass
	else:
		for i in range(len(rockets_times)):
			rockets_times[i] = 0

func _on_MusicPlayer_finished()->void:
	music_player.play()

func _on_EVENTS_spark_nb_changed(value : int) -> void:
	if nb_spark == 0 and value >0 :
		sound_player.stream = fuse_sound
		sound_player.play()
	nb_spark += value
	if nb_spark <= 0:
		sound_player.stop() 

func _on_EVENTS_fuse_node_nb_changed(_value:int)->void:
	fuse_left_gauge.set_value_no_signal(node_nb_max - get_node("%MouseController").nb_fuse_nodes)

func _on_SoundPlayer_finished() -> void:
	if sound_player.stream == fuse_sound:
		sound_player.play()

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
			create_pop_up_dialog('Tu as réussi, bien joué !',detonator_dialog_pos)
			back_to_menu.set_message("Congrats ! Back to menu ?")
			await get_tree().create_timer(3.0).timeout
			transition_animation.play("Transi_IN",-1,-1.0,true)
			await transition_animation.animation_finished
			transition.visible = false
			firework_animation.play("fly_in",-1,1.0)
			firework_visualizer.visible = true
		else:
			create_pop_up_dialog('Ca n\'a pas fonctionné, dommage... Essaie encore une fois !',detonator_dialog_pos)
			print("It didn\'t work... Try again !")

func _on_EVENTS_play_pop_up_dialog(text : String, pos: Vector2) -> void:
	create_pop_up_dialog(text, pos)
