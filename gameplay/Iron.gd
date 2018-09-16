extends StaticBody2D

export (int) var ironCapacity
var iron

func _ready():
	iron = ironCapacity

func harvest():
	if iron > 0:
		iron -= 1
		return {
			'type': 'iron',
			'texture': $Sprite.texture,
			'quantity': 1
		}