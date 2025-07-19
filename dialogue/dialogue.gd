extends CanvasLayer

signal dialogue_started
signal line_started(line_idx: int)
signal line_finished(line_idx: int)
signal dialogue_finished

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var icon: TextureRect = %Icon

var current_dialogue: Array[DialogueLine]
var current_index := 0
var in_dialogue := false
var last_line := false

func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if not in_dialogue:
		return
	
	if event.is_action_pressed("forward_dialogue") and rich_text_label.visible_ratio == 1.0:
		if not last_line:
			_play_line()
		else:
			in_dialogue = false
			hide()
			get_tree().paused = false
			dialogue_finished.emit()


func show_dialogue(dialogue: Array[DialogueLine]) -> void:
	get_tree().paused = true
	dialogue_started.emit()
	current_index = 0
	in_dialogue = true
	last_line = false
	current_dialogue = dialogue.duplicate()
	show()
	_play_line()


func _play_line() -> void:
	icon.hide()
	rich_text_label.text = current_dialogue[current_index].text
	var tween := rich_text_label.create_tween()
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, current_dialogue[current_index].reveal_duration).from(0.0)
	line_started.emit(current_index)
	
	tween.finished.connect(
		func():
			line_finished.emit(current_index)
			current_index += 1
			icon.show()
			if current_index == current_dialogue.size():
				last_line = true
	)
