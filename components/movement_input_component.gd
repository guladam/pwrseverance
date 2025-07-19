class_name MovementInputComponent
extends Node

var direction: Vector2


func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
