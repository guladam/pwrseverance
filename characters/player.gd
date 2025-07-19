class_name Player
extends CharacterBody2D

@export var character_stats: CharacterStats
@export var move_stats: MoveStats
@export var move_sound_threshold := 0.25

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dash_sound: AudioStreamPlayer = %DashSound
@onready var sword_sound: AudioStreamPlayer = %SwordSound
@onready var move_sound: AudioStreamPlayer = %MoveSound
@onready var sword_hit_sound: AudioStreamPlayer = %SwordHitSound
@onready var move_sound_timer: Timer = %MoveSound/MoveSoundTimer
@onready var jump_component: JumpComponent = %JumpComponent
@onready var floating_text_component: FloatingTextManagerComponent = %FloatingTextManagerComponent
@onready var left_weapon_hitbox: HitboxComponent = %LeftWeaponHitbox
@onready var dash_component: DashComponent = $Components/DashComponent
@onready var flash_component: FlashComponent = $Components/FlashComponent
@onready var hurtbox: HurtboxComponent = $Hurtbox
@onready var movement_input_component: MovementInputComponent = $Components/MovementInputComponent

var can_move := true

func _ready() -> void:
	left_weapon_hitbox.damage = character_stats.auto_attack_damage
	left_weapon_hitbox.hit_hurtbox.connect(sword_hit_sound.play.unbind(1))
	jump_component.jumped.connect(_on_jumped)
	jump_component.jump_finished.connect(move_sound_timer.start)
	move_sound_timer.timeout.connect(_on_move_sound_timer_timeout)
	dash_component.dash_started.connect(_on_dash_started)
	dash_component.dash_ended.connect(_on_dash_ended)
	hurtbox.hurt.connect(flash_component.flash.bind(Color.RED).unbind(1))


func _physics_process(_delta: float) -> void:
	if can_move:
		velocity = movement_input_component.direction * move_stats.speed
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("skill1") and not animation_player.is_playing():
		animation_player.play("sword_slash")
		sword_sound.play()


func hide_weapons() -> void:
	%LeftHandWeapon.hide()


func show_weapons() -> void:
	%LeftHandWeapon.show()


func _on_jumped() -> void:
	move_sound.stop()
	move_sound_timer.stop()


func _on_move_sound_timer_timeout() -> void:
	var x_dir_moving: bool = abs(movement_input_component.direction.x) > move_sound_threshold
	var y_dir_moving: bool = abs(movement_input_component.direction.y) > move_sound_threshold
	if x_dir_moving or y_dir_moving:
		move_sound.play()


func _on_dash_started() -> void:
	dash_sound.play()
	can_move = false
	flash_component.flash()
	hurtbox.is_invincible = true


func _on_dash_ended() -> void:
	can_move = true
	hurtbox.is_invincible = false
