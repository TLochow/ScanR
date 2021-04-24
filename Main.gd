extends Node2D

onready var Player = $Player
onready var FadeRect = $UI/FadeRect
onready var FadeTween = $UI/FadeRect/Tween
onready var Noise = $Noise

var RespawnPoint

var MakeNoise = false
var SimplexNoise = OpenSimplexNoise.new()
var NoiseLevel = -80.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("restart"):
		Respawn()

func _ready():
	randomize()
	$CanvasModulate.visible = true
	RespawnPoint = Player.get_position()
	FadeIn()

func _process(delta):
	if MakeNoise:
		var goal = ((SimplexNoise.get_noise_1d(OS.get_ticks_msec() * 0.001) - 1.0) * 15.0)
		NoiseLevel = lerp(NoiseLevel, goal, delta)
		Noise.volume_db = NoiseLevel

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

func _on_NoiseStarter_body_entered(body):
	SimplexNoise.seed = randi()
	SimplexNoise.octaves = 4
	SimplexNoise.period = 20.0
	SimplexNoise.persistence = 0.8
	MakeNoise = true

func _on_BoulderDropper_body_entered(body):
	$Level/Boulders/BoulderBlocker.call_deferred("queue_free")
	$Level/Boulders/Boulder4.linear_velocity *= 1.0
	$Level/Boulders/Boulder5.linear_velocity *= 1.0
	$Level/Boulders/Boulder6.linear_velocity *= 1.0
	$Level/Boulders/Boulder7.linear_velocity *= 1.0
	$Level/Boulders/Boulder8.linear_velocity *= 1.0
