extends KinematicBody2D

var Scanable = false

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var Pos = get_position()

onready var Ray = $RayCast2D
onready var AttackTween = $Tween
onready var GruntTimer = $Sounds/GruntTimer

var Mode = 1

func _physics_process(delta):
	if Mode == 1:
		var playerPos = Player.get_position()
		var playerDir = playerPos - Pos
		rotation = lerp_angle(rotation, playerDir.angle(), 0.5)
		if Ray.is_colliding():
			var collider = Ray.get_collider()
			if collider == Player:
				Mode = 2
				var nodeName = "Sounds/Attack" + str((randi() % 4) + 1)
				get_node(nodeName).play()
				AttackTween.interpolate_property(self, "position", Pos, playerPos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
				AttackTween.start()

func _on_Tween_tween_all_completed():
	if Mode == 2:
		Mode = 3
		AttackTween.interpolate_property(self, "position", get_position(), Pos, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		AttackTween.start()
	else:
		Mode = 1

func _on_PlayerDetector_body_entered(body):
	if body.has_method("Die"):
		body.Die()

func _on_GruntTimer_timeout():
	var nodeName = "Sounds/Grunt" + str((randi() % 7) + 1)
	get_node(nodeName).play()
	GruntTimer.wait_time = rand_range(5.0, 15.0)
