class_name FloatingCombatText
extends Label

func show_value(value: String, travel: Vector2, duration: float, spread: float, crit: bool=false):
	text = value
	var movement = travel.rotated(randf_range(-spread/2, spread/2))
	pivot_offset = get_rect().size / 2
	var tween := self.create_tween()
	tween.tween_property(self, "position", position + movement, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	if crit:
		modulate = Color.RED
		tween.tween_property(self, "scale", scale, duration).from(scale * 2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	tween.finished.connect(queue_free)
