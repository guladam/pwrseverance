class_name Player
extends CharacterBody2D

@export var move_stats: MoveStats

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var move_input = Input.get_axis("down", "up")
	var rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * move_input * move_stats.speed
	rotation += rotation_direction * move_stats.rotation_speed * delta
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("skill1") and not animation_player.is_playing():
		animation_player.play("sword_slash")
