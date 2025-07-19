class_name Dummy
extends StaticBody2D

@export var stats: CharacterStats

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var floating_text_manager_component: FloatingTextManagerComponent = $FloatingTextManagerComponent

func _ready() -> void:
	hurtbox_component.hurt.connect(
		func(hitbox: HitboxComponent) -> void:
			floating_text_manager_component.show_value(hitbox.damage)
			get_tree().create_timer(0.4).timeout.connect(
				func():
					stats.health += hitbox.damage
			)
	)
