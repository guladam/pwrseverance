extends Node2D

@export var tutorial_lines: DialogueLines

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var walk_door_trigger: WalkTriggerComponent = $WalkDoorTrigger
@onready var door_component: DoorComponent = $WallLayer/DoorComponent


func start_tutorial_dialogue() -> void:
	Dialogue.show_dialogue(tutorial_lines.lines)
	Dialogue.dialogue_finished.connect(start_game, CONNECT_ONE_SHOT)

func start_game() -> void:
	animation_player.play("zoom_out")
	walk_door_trigger.triggered.connect(door_component.open)
