extends Node2D

onready var Player = $Player
onready var FadeRect = $UI/FadeRect
onready var FadeTween = $UI/FadeRect/Tween

var RespawnPoint

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _ready():
	$CanvasModulate.visible = true
	RespawnPoint = Player.get_position()
	FadeIn()

func Respawn():
	FadeOut()
	yield(FadeTween, "tween_all_completed")
	Player.set_position(RespawnPoint)
	Player.Alive = true
	FadeIn()

func FadeIn():
	FadeTween.interpolate_property(FadeRect, "color", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	FadeTween.start()

func FadeOut():
	FadeTween.interpolate_property(FadeRect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	FadeTween.start()

func _on_DeathArea_body_entered(body):
	Respawn()

func _on_SavePoint_body_entered(body):
	RespawnPoint = Player.get_position()
