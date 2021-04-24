extends RayCast2D

var Direction
var DrawPos = Vector2(0.0, 0.0)
var CollidingPos = Vector2(0.0, 0.0)
var Hit = false

var LaserColor

func _ready():
	LaserColor = Color.from_hsv(rand_range(0.0, 0.2), 1.0, 1.0)
	cast_to = Direction.normalized() * 515.0
	DrawPos = cast_to

func _process(delta):
	force_raycast_update()
	if is_colliding():
		CollidingPos = get_collision_point()
		DrawPos = to_local(CollidingPos)
		Hit = true
	update()

func _draw():
	draw_line(Vector2(0.0, 0.0), DrawPos, LaserColor, 1.0, true)

func _on_Timer_timeout():
	if Hit:
		var pixelHandler = get_tree().get_nodes_in_group("PixelHandler")[0]
		pixelHandler.RegisterPixel(CollidingPos, LaserColor)
	call_deferred("queue_free")
