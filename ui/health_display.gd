extends Label

@export var player_stats: CharacterStats

func _ready() -> void:
	player_stats.changed.connect(
		func():
			text = "Health: %s/100" % [player_stats.health]
	)
