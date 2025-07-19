class_name FloatingTextManagerComponent
extends Node

@export var spawner_component: SpawnerComponent
@export var travel := Vector2(0, -80)
@export var duration := 2.0
@export var spread := PI/2


func show_value(value: int, crit: bool=false) -> void:
	var floating_text: FloatingCombatText = spawner_component.spawn()
	floating_text.show_value(str(value), travel, duration, spread, crit)
