extends Area2D

export(bool) var On = false
export(NodePath) var ToggleObjectPath
onready var ToggleObject = get_node(ToggleObjectPath)

onready var SpriteNode = $Sprite
onready var LabelNode = $Label

var Active = false
var Toggled = false

func _ready():
	SpriteNode.flip_v = On

func _on_Lever_body_entered(body):
	Active = true
	LabelNode.visible = true

func _on_Lever_body_exited(body):
	Active = false
	LabelNode.visible = false

func _input(event):
	if Active and event.is_action_pressed("ui_accept"):
		On = !On
		SpriteNode.flip_v = On
		if not Toggled:
			Toggled = true
			ToggleObject.Toggle(On)
