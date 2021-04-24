extends Node2D

export(float, 0.0, 10.0) var StartDelay = 0.0

func _ready():
	$StartTimer.wait_time = StartDelay + 0.1
	$StartTimer.start()

func _on_StartTimer_timeout():
	$AnimationPlayer.play("Move")
