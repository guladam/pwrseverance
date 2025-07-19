class_name DashComponent
extends Node

signal dash_started
signal dash_ended

@export var actor: CharacterBody2D
@export var movement_dir_component: MovementInputComponent
@export var dash_distance: int
@export var dash_duration := 0.3
@export var cd_timer: Timer

var dashing := false
var dash_time_elapsed := 0.0
var dash_dir: Vector2

func _process(delta: float) -> void:
	if dash_time_elapsed >= dash_duration:
		_end_dash()
	elif dashing:
		dash_time_elapsed += delta


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("dash") or dashing or cd_timer.time_left > 0.0:
		return
	
	dash_dir = movement_dir_component.direction
	if dash_dir == Vector2.ZERO:
		return
	
	dash_time_elapsed = 0.0
	actor.velocity = dash_dir * (dash_distance / dash_duration)
	dash_started.emit()
	dashing = true


func _end_dash() -> void:
	dash_time_elapsed = 0.0
	actor.velocity = Vector2.ZERO
	dash_ended.emit()
	dashing = false
	cd_timer.start()
