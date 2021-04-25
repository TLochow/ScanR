extends KinematicBody2D

signal Died

var LASERSCENE = preload("res://Laser.tscn")

onready var SpriteNode = $Sprite
onready var AnimationPlayerNode = $AnimationPlayer
onready var LaserNode = get_tree().get_nodes_in_group("LaserNode")[0]

var Motion = Vector2(0.0, 0.0)

var coyoteTime = 0.0
var Alive = true

func _physics_process(delta):
	if Alive:
		Motion.y = min(Motion.y + (600.0 * delta), 300.0)
		
		var pos = get_position()
		var mousePos = .get_global_mouse_position()
		if mousePos.x < pos.x:
			SpriteNode.flip_h = true
		else:
			SpriteNode.flip_h = false
		
		if Input.is_action_pressed("mouse_left"):
			for i in range(5):
				var laser = LASERSCENE.instance()
				laser.set_position(pos)
				laser.Direction = (mousePos - pos).rotated(rand_range(-0.3, 0.3))
				LaserNode.call_deferred("add_child", laser)
		
		var isOnFloor = is_on_floor()
		
		var xMove = 0.0
		if Input.is_action_pressed("ui_left"):
			xMove += -100.0
		if Input.is_action_pressed("ui_right"):
			xMove += 100.0
		if Input.is_action_just_pressed("ui_up") and coyoteTime > 0.0:
			Motion.y = -250.0
		
		Motion.x = xMove
		
		Motion = move_and_slide_with_snap(Motion, Vector2(0.0, -32.0), Vector2(0.0, -1.0), false, 4, 0.785398, false)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if collider is RigidBody2D:
				collider.apply_central_impulse(-collision.normal * 30.0)
		
		var moving = false
		if Motion.x < -1.0:
			moving = true
		elif Motion.x > 1.0:
			moving = true
		if isOnFloor:
			coyoteTime = 0.1
			if moving:
				SwitchAnimation(AnimationPlayerNode, "Walk")
			else:
				SwitchAnimation(AnimationPlayerNode, "Idle")
		else:
			coyoteTime -= delta
			if Motion.y < 0.0:
				SwitchAnimation(AnimationPlayerNode, "Jump")
			elif Motion.y > 0.0:
				SwitchAnimation(AnimationPlayerNode, "Fall")

func SwitchAnimation(animationPlayer, animation):
	if animationPlayer.current_animation != animation:
		animationPlayer.play(animation)

func Die():
	if Alive:
		Alive = false
		emit_signal("Died")
