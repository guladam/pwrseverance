class_name WalkTriggerComponent
extends Area2D

signal triggered

@export var trigger_once := true

func _ready() -> void:
	body_entered.connect(
		func(_body: CharacterBody2D):
			triggered.emit()
			if trigger_once:
				_disable_collision_shapes()
	)


func _disable_collision_shapes() -> void:
	for child in get_children():
		if not child is CollisionShape2D and not child is CollisionPolygon2D:
			continue
		child.set_deferred("disabled", true)
