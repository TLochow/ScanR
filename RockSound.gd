extends AudioStreamPlayer2D

func _ready():
	if get_tree().get_nodes_in_group("RockSound").size() < 10:
		play()
	else:
		call_deferred("queue_free")

func _on_RockSound_finished():
	queue_free()
