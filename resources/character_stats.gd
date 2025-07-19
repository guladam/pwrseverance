class_name CharacterStats
extends Resource

signal no_health()

@export var health: int = 100:
	set(value):
		health = value
		emit_changed()
		
		if health <= 0:
			no_health.emit()

@export var auto_attack_damage := 5
