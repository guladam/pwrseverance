class_name HitboxComponent
extends Area2D

signal hit_hurtbox(hurtbox)

@export var damage := 1


func _ready() -> void:
	area_entered.connect(_on_hurtbox_entered)


func _on_hurtbox_entered(hurtbox: HurtboxComponent) -> void:
	if not hurtbox is HurtboxComponent:
		return
	if hurtbox.is_invincible:
		return

	hit_hurtbox.emit(hurtbox)
	hurtbox.hurt.emit(self)
