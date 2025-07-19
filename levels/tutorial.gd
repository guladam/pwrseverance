extends Node2D

@export var room1_lines: DialogueLines
@export var room2_lines: DialogueLines
@export var room2_lines_2: DialogueLines
@export var room3_lines: DialogueLines

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var walk_door_trigger: WalkTriggerComponent = $WalkDoor1Trigger
@onready var second_room_enter_trigger: WalkTriggerComponent = $SecondRoomEnterTrigger
@onready var third_room_enter_trigger: WalkTriggerComponent = $ThirdRoomEnterTrigger
@onready var door_1: DoorComponent = %Door1
@onready var door_2: DoorComponent = %Door2
@onready var door_3: DoorComponent = %Door3
@onready var dummy1: StaticBody2D = %Dummy1

var dummy1_hit_counter := 0


func start_tutorial_dialogue() -> void:
	Dialogue.show_dialogue(room1_lines.lines)
	Dialogue.dialogue_finished.connect(start_game, CONNECT_ONE_SHOT)
	second_room_enter_trigger.triggered.connect(start_second_room)


func start_game() -> void:
	animation_player.play("zoom_out")
	walk_door_trigger.triggered.connect(door_1.open)


func start_second_room() -> void:
	door_1.close()
	Dialogue.show_dialogue(room2_lines.lines)
	Dialogue.line_finished.connect(func(_idx): $Player.show_weapons(), CONNECT_ONE_SHOT)
	Dialogue.line_started.connect(_on_second_room_line_started)
	Dialogue.dialogue_finished.connect(second_room_count_hits, CONNECT_ONE_SHOT)
	third_room_enter_trigger.triggered.connect(start_third_room)


func second_room_count_hits() -> void:
	dummy1.hurtbox_component.hurt.connect(_on_second_room_dummy_hurt)


func second_room_last_dialogue() -> void:
	Dialogue.show_dialogue(room2_lines_2.lines)
	Dialogue.dialogue_finished.connect(door_2.open, CONNECT_ONE_SHOT)


func _on_second_room_dummy_hurt(_hitbox: HitboxComponent) -> void:
	dummy1_hit_counter += 1
	if dummy1_hit_counter == 5:
		get_tree().create_timer(0.4).timeout.connect(
			func():
				second_room_last_dialogue()
				dummy1.hurtbox_component.hurt.disconnect(_on_second_room_dummy_hurt)
		, CONNECT_ONE_SHOT
		)


func _on_second_room_line_started(idx: int) -> void:
	if idx == 2:
		animation_player.play("show_barrel")
		Dialogue.line_started.disconnect(_on_second_room_line_started)


func start_third_room() -> void:
	Dialogue.show_dialogue(room3_lines.lines)
	Dialogue.dialogue_finished.connect(
		func():
			door_3.open()
			$Dummy2.start_attacking()
	, CONNECT_ONE_SHOT
	)
