class_name WalkTriggerComponent
extends Area2D

signal triggered

@export var trigger_once := true

func _ready() -> void:
	body_entered.connect(
		func(_body: CharacterBody2D):
			triggered.emit()
			if trigger_once:
				queue_free()
	)
