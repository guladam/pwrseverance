class_name RotateTowardsMouseComponent
extends Node

@export var target: Node2D
@export var game_settings: GameSettings


func _process(delta: float) -> void:
	var direction = target.get_global_mouse_position() - target.global_position
	target.global_rotation = lerp_angle(target.global_rotation, direction.angle(), game_settings.aim_sensitivity * delta)
