extends Node2D
class_name Level

@export var lvl_id : int = 0
@export_range(0, 20000) var node_nb_max : int = 500
@export var fuse_sound : Resource
@export var dialog_box_scene : Resource

@export var forground1 : Resource = null
@export var forground1_n : Resource = null
@export var forground2 : Resource = null
@export var forground2_n : Resource = null

@onready var music_player = $MusicPlayer
@onready var sound_player = $SoundPlayer

@onready var firework_visualizer = $FireworkVisualizer
@onready var firework_animation = $FireworkVisualizer/AnimationPlayer
@onready var firework_musicplayer = $FireworkVisualizer/MusicPlayer
@onready var back_to_menu = $FireworkVisualizer/UI/Back_To_Menu
@onready var retry_button = $FireworkVisualizer/UI/RetryButton
@onready var quit_button = $FireworkVisualizer/UI/QuitButton

@onready var transition_animation = $AnimationPlayer
@onready var transition = $Visuals/Animation

@onready var fuse_left_gauge = $UI/FuseLeftGauge/ProgressBar
@onready var fuse_left_gauge_anim = $UI/FuseLeftGauge/AnimationPlayer

@onready var reload_help = $UI/ReloadHelp
@onready var reload_help_label = $UI/ReloadHelp/Label
@onready var reload_help_anim = $UI/ReloadHelp/AnimationPlayer
@onready var reload_help_timer = $UI/ReloadHelp/Timer

@onready var timer = $Timer

var detonator_dialog_pos = Vector2.ZERO

var rockets = []
var rockets_times = []

var last_score = 0 : set=set_last_score
var best_score = 0

var nb_spark:int = 0

### ACCESSORS

func set_last_score(new_val : int)->void:
	last_score = max(1000 - new_val,0)
	if last_score > best_score:
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
	timer.timeout.connect(_on_Timer_timeout)
	sound_player.finished.connect(_on_SoundPlayer_finished)
	music_player.finished.connect(_on_MusicPlayer_finished)
	music_player.play()
	## TEMP pour debug
	PLAYER.load_data(PLAYER.player_file_path)
	best_score = PLAYER.current_data['score_by_level'][lvl_id]
	##
	update_score_display()
	reload_help.visible = false
	reload_help_label.text = tr("UI_RELOAD_HELP")
	reload_help_anim.play("Idle")
	reload_help_timer.timeout.connect(_on_ReloadHelpTimer_timeout)
	$UI/FuseLeftGauge/Label.text = tr("UI_FUSE_LEFT")
	retry_button.text = tr("UI_CONTINUE_LEVEL")
	quit_button.text = tr("UI_QUIT_TO_MENU")
	firework_musicplayer.volume_db = -80
	firework_animation.stop()
	transition_animation.play("Transi_IN", -1, 1.0)
	
	if forground1 != null:
		$FireworkVisualizer/Animations/Bckg_2.texture.diffuse_texture = forground1
		$FireworkVisualizer/Animations/Bckg_2.texture.normal_texture = forground1_n
	if forground2 != null:
		$FireworkVisualizer/Animations/Bckg_3.texture.diffuse_texture = forground2
		$FireworkVisualizer/Animations/Bckg_3.texture.normal_texture = forground2_n
	
	
	fuse_left_gauge.min_value = 0
	fuse_left_gauge.max_value = node_nb_max
	fuse_left_gauge.set_value_no_signal(node_nb_max - get_node("%MouseController").nb_fuse_nodes)
	
	detonator_dialog_pos = $Detonator.global_position
	detonator_dialog_pos.y -= 50.0
	create_pop_up_dialog(tr("POPUP_LETS_GO"),detonator_dialog_pos)

### LOGIC

func connect_rocket(rocket) -> void:
	rocket.rocket_id = len(rockets)
	rockets.append(rocket)
	rockets_times.append(0)
	rocket.rocket_start.connect(_on_Rocket_rocket_start)
	
func update_score_display()->void:
	$UI/ScoreLabel.text = tr("UI_BEST_SCORE") + "\n  "
	if best_score == -1:
		$UI/ScoreLabel.text += '-'
	else :
		$UI/ScoreLabel.text += str(best_score)
	$UI/ScoreLabel.text += '\n' + tr("UI_LAST_SCORE") + "\n  "
	if last_score == -1:
		$UI/ScoreLabel.text += '-'
	else :
		$UI/ScoreLabel.text += str(last_score)

func create_pop_up_dialog(text:String, pos:Vector2)->void:
	var new_box = dialog_box_scene.instantiate()
	add_child(new_box)
	new_box.display_text(text, pos)

### SIGNAL RESPONSES

func _on_EVENTS_has_detonated(new_value:bool)->void:
	if new_value:
		reload_help_timer.start(10)
	else:
		timer.stop()
		reload_help_timer.stop()
		reload_help.visible = false
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
		var score = ((rockets_times.max() - rockets_times.min()) / Engine.get_frames_per_second() ) * 1000
		set_last_score(score)
		update_score_display()
		print(rockets_times)
		print("Your score : " + str(score))
		print(str(Engine.get_frames_per_second()) + " FPS ")
		if score < GAME.WIN_MARGIN * 1000 :
			print("You won !")
			create_pop_up_dialog(tr("POPUP_WIN"),detonator_dialog_pos)
			back_to_menu.set_message("Congrats ! Back to menu ?")
			timer.start(3.0)
		else:
			create_pop_up_dialog(tr("POPUP_LOSE"),detonator_dialog_pos)
			print("It didn\'t work... Try again !")

func _on_EVENTS_play_pop_up_dialog(text : String, pos: Vector2) -> void:
	create_pop_up_dialog(text, pos)

func _on_Timer_timeout():
	print("On timer timeout")
	timer.stop()
	transition_animation.play("Transi_IN",-1,-1.0,true)
	await transition_animation.animation_finished
	music_player.volume_db = -80
	transition.visible = false
	firework_animation.play("fly_in",-1,1.0)
	firework_visualizer.visible = true

func _on_ReloadHelpTimer_timeout():
	var tween = get_tree().create_tween()
	reload_help.modulate.a = 0
	reload_help.visible = true
	tween.tween_property(reload_help, "modulate", Color.WHITE, 1)
