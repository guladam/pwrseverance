class_name JumpComponent
extends Node

signal jumped
signal jump_finished

@export var anim_player: AnimationPlayer
@export_range(0.0, 1.0, 0.01) var coyote_threshold := 0.8
@export var sfx: AudioStreamPlayer

var queued_jumps := 0


func _ready() -> void:
	anim_player.animation_finished.connect(
		func(anim: StringName):
			if anim == "jump":
				jump_finished.emit()
				if queued_jumps > 0:
					_jump()
					queued_jumps -= 1
	)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("jump"):
		return
	
	if anim_player and anim_player.is_playing():
		if anim_player.current_animation == "jump" and anim_player.current_animation_position / anim_player.current_animation_length >= coyote_threshold:
			queued_jumps += 1
		return
	
	_jump()

func _jump() -> void:
	anim_player.play("jump")
	if sfx:
		sfx.play()
	jumped.emit()
