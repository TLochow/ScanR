extends Node2D

export(bool) var OpenLeft = true
export(bool) var Open = false
var IsOpen

onready var AnimPlayer = $AnimationPlayer
onready var ChangeTrigger = $ChangeTrigger

func _ready():
	IsOpen = Open
	if Open:
		if OpenLeft:
			$StaticBody2D.rotation_degrees = 90.0
		else:
			$StaticBody2D.rotation_degrees = -90.0

func Toggle(value):
	Open = value
	ChangeTrigger.start()

func _on_ChangeTrigger_timeout():
	if not AnimPlayer.is_playing():
		if Open == IsOpen:
			ChangeTrigger.stop()
		else:
			var animation
			if Open:
				animation = "Open"
			else:
				animation = "Close"
			if OpenLeft:
				animation += "Left"
			else:
				animation += "Right"
			AnimPlayer.play(animation)

func _on_AnimationPlayer_animation_finished(anim_name):
	IsOpen = anim_name.begins_with("Open")
