class_name DashComponent
extends Node

signal dash_started
signal dash_ended

@export var actor: CharacterBody2D
@export var dash_distance: int
@export var dash_duration := 0.3

var dashing := false
var dash_time_elapsed := 0.0


func _process(delta: float) -> void:
	if dash_time_elapsed >= dash_duration:
		_end_dash()
	elif dashing:
		dash_time_elapsed += delta


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("dash") or dashing:
		return
	
	dash_time_elapsed = 0.0
	actor.velocity = actor.transform.x * (dash_distance / dash_duration)
	dash_started.emit()
	dashing = true


func _end_dash() -> void:
	actor.velocity = Vector2.ZERO
	dash_ended.emit()
	dashing = false
