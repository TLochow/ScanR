extends Sprite

var PixelColor

func _ready():
	var transparent = PixelColor
	transparent.a = 0.0
	$Tween.interpolate_property(self, "modulate", PixelColor, transparent, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
