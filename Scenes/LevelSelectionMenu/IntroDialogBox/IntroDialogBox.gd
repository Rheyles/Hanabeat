extends MarginContainer

@onready var label = $MarginContainer/ Label
@onready var timer = $LetterDisplayTimer

var MAX_WIDTH : int = 400

var text : String = ""
var letter_index : int = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

#signal finished_displaying()

func _ready():
	timer.timeout.connect(_on_LetterDisplayTimer_timeout)

func display_text(text_to_display : String, pos : Vector2) -> void:
	text = text_to_display
	label.text = text_to_display
	
	await self.resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	#size.x = clamp(size.x, 0, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.set_autowrap_mode(2)
		await self.resized
		#await self.resized
		custom_minimum_size.y = size.y
		
	
	position.x = pos.x - size.x / 2
	position.y = pos.y - size.y
	
	label.text = ""
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	await tween.finished
	_display_letter()


func _display_letter() -> void:
	label.text += text[letter_index]
	
	letter_index+=1
	if letter_index >= text.length():
		#$EndTimer.start()
		#await $EndTimer.timeout
		#var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		#tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
		#await tween.finished
		#queue_free()
		return
	
	else :
		match text[letter_index]:
			"!", ".", ",", "?" :
				timer.start(punctuation_time)
			" ":
				timer.start(space_time)
			_:
				timer.start(letter_time)


func _on_LetterDisplayTimer_timeout() -> void:
	_display_letter()
