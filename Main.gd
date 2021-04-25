extends Node2D

onready var Player = $Player
onready var FadeRect = $UI/FadeRect
onready var FadeTween = $UI/FadeRect/Tween
onready var Noise = $Noise

var RespawnPoint
var Respawning = false

var MakeNoise = false
var SimplexNoise = OpenSimplexNoise.new()
var NoiseLevel = -80.0

var EndSecurity = 1
var CreditsOver = false

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
		var goal = ((SimplexNoise.get_noise_1d(OS.get_ticks_msec() * 0.001) - 1.0) * 15.0) + 20.0
		NoiseLevel = lerp(NoiseLevel, goal, delta)
		Noise.volume_db = NoiseLevel

func Respawn():
	if not Respawning:
		Respawning = true
		FadeOut()
		yield(FadeTween, "tween_all_completed")
		Player.set_position(RespawnPoint)
		Player.Alive = true
		Respawning = false
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
	if not MakeNoise:
		MakeNoise = true
		SimplexNoise.seed = randi()
		SimplexNoise.octaves = 4
		SimplexNoise.period = 20.0
		SimplexNoise.persistence = 0.8

func _on_BoulderDropper_body_entered(body):
	$Level/Boulders/BoulderBlocker.call_deferred("queue_free")
	$Level/Boulders/Boulder4.linear_velocity *= 1.0
	$Level/Boulders/Boulder5.linear_velocity *= 1.0
	$Level/Boulders/Boulder6.linear_velocity *= 1.0
	$Level/Boulders/Boulder7.linear_velocity *= 1.0
	$Level/Boulders/Boulder8.linear_velocity *= 1.0

func Toggle(value):
	$Level/Doors/Door6.Toggle(true)
	$Level/Doors/Door7.Toggle(true)
	$Level/Boulders/EndBouldersTimer.start()

func _on_EndBouldersTimer_timeout():
	var bodies = $Level/Boulders/EndBouldersDangerArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Boulders"):
			if EndSecurity < 3:
				body.linear_velocity += Vector2(rand_range(-100.0, 100.0), rand_range(-100.0, 100.0))
			elif EndSecurity == 3:
				var newPolygon = PoolVector2Array([Vector2(0.0, -2.0), Vector2(2.0, 0.0), Vector2(0.0, 2.0), Vector2(-2.0, 0.0)])
				body.get_node("CollisionPolygon2D").polygon = newPolygon
				body.linear_velocity *= 1.0
			else:
				body.call_deferred("queue_free")
				$Level/Boulders/EndBouldersTimer.stop()
	EndSecurity += 1

func _on_EndTrigger_body_entered(body):
	if Player.Alive:
		Player.Alive = false
		$UI/Credits/EndTween.interpolate_property($UI/Credits, "margin_top", 360, -580, 25.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Credits/EndTween.start()

func _on_EndTween_tween_all_completed():
	if CreditsOver:
		get_tree().quit()
	else:
		CreditsOver = true
		$UI/Credits/EndTween.interpolate_property(FadeRect, "color", Color(0.0, 0.0, 0.0, 0.0), Color(0.0, 0.0, 0.0, 1.0), 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Credits/EndTween.start()
