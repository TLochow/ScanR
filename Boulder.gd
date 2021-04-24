extends RigidBody2D

var ROCKSOUNDSCENE = preload("res://RockSound.tscn")

var Scanable = false

func _on_Boulder_body_entered(body):
	var sound = ROCKSOUNDSCENE.instance()
	sound.set_position(get_position())
	get_parent().add_child(sound)
