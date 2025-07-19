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

var direction: Vector2
var can_move := true

func _ready() -> void:
	left_weapon_hitbox.damage = character_stats.auto_attack_damage
	left_weapon_hitbox.hit_hurtbox.connect(sword_hit_sound.play.unbind(1))
	jump_component.jumped.connect(_on_jumped)
	jump_component.jump_finished.connect(move_sound_timer.start)
	move_sound_timer.timeout.connect(_on_move_sound_timer_timeout)
	dash_component.dash_started.connect(_on_dash_started)
	dash_component.dash_ended.connect(_on_dash_ended)


func _physics_process(_delta: float) -> void:
	if can_move:
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


func _on_jumped() -> void:
	move_sound.stop()
	move_sound_timer.stop()


func _on_move_sound_timer_timeout() -> void:
	if abs(direction.x) > move_sound_threshold or abs(direction.y) > move_sound_threshold:
		move_sound.play()


func _on_dash_started() -> void:
	dash_sound.play()
	can_move = false
	flash_component.flash()
	hurtbox.is_invincible = true


func _on_dash_ended() -> void:
	can_move = true
	hurtbox.is_invincible = false
