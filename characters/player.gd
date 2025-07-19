class_name Player
extends CharacterBody2D

@export var character_stats: CharacterStats
@export var move_stats: MoveStats
@export var move_sound_threshold := 0.25

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_sound: AudioStreamPlayer = %SwordSound
@onready var move_sound: AudioStreamPlayer = %MoveSound
@onready var sword_hit_sound: AudioStreamPlayer = %SwordHitSound
@onready var move_sound_timer: Timer = %MoveSound/MoveSoundTimer
@onready var jump_component: JumpComponent = %JumpComponent
@onready var floating_text_component: FloatingTextManagerComponent = %FloatingTextManagerComponent
@onready var left_weapon_hitbox: HitboxComponent = %LeftWeaponHitbox

var direction: Vector2

func _ready() -> void:
	left_weapon_hitbox.damage = character_stats.auto_attack_damage
	left_weapon_hitbox.hit_hurtbox.connect(
		func(_hurtbox: HurtboxComponent):
			sword_hit_sound.play()
	)
	jump_component.jumped.connect(
		func():
			move_sound.stop()
			move_sound_timer.stop()
	)
	jump_component.jumped.connect(
		func():
			move_sound_timer.start()
	)
	move_sound_timer.timeout.connect(
		func():
			if abs(direction.x) > move_sound_threshold or abs(direction.y) > move_sound_threshold:
				move_sound.play()
	)

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * move_stats.speed
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("skill1") and not animation_player.is_playing():
		animation_player.play("sword_slash")
		sword_sound.play()


func hide_weapons() -> void:
	%LeftHandWeapon.hide()


func show_weapons() -> void:
	%LeftHandWeapon.show()
