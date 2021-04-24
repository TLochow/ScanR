extends AudioStreamPlayer2D

func _on_RockSound_finished():
	queue_free()
