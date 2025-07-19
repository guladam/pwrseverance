class_name HurtComponent
extends Node

@export var stats: CharacterStats
@export var hurtbox_component: HurtboxComponent

func _ready() -> void:
	hurtbox_component.hurt.connect(func(hitbox_component: HitboxComponent):
		stats.health -= hitbox_component.damage
	)
