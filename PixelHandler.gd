extends Node2D

onready var PixelSpritesNode = $PixelSprites

var PixelImageSize = Vector2(512.0, 512.0)

var Images = {}
var Sprites = {}

func PrepareSprite(pos):
	var sprite = Sprite.new()
	var imageTexture = ImageTexture.new()
	var image = Image.new()
	image.create(PixelImageSize.x, PixelImageSize.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(1.0, 1.0, 1.0, 0.0))
	image.lock()
	imageTexture.create_from_image(image)
	sprite.texture = imageTexture
	sprite.set_position((pos * PixelImageSize) + (PixelImageSize * 0.5))
	Images[pos] = image
	Sprites[pos] = sprite
	PixelSpritesNode.add_child(sprite)

func RegisterPixel(pos, color):
	var keyPos = Vector2(floor(pos.x / PixelImageSize.x), floor(pos.y / PixelImageSize.y))
	if not Images.has(keyPos):
		PrepareSprite(keyPos)
	var image = Images[keyPos]
	var x = fmod(pos.x, PixelImageSize.x)
	var y = fmod(pos.y, PixelImageSize.y)
	if x < 0.0:
		x = PixelImageSize.x + x
	if y < 0.0:
		y = PixelImageSize.y + y
	image.set_pixel(x, y, color)
	Sprites[keyPos].texture.set_data(image)
