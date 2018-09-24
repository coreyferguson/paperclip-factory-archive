tool
extends StaticBody2D

export (String) var type
export (Texture) var texture
export (int) var capacity = 500
export (int) var quantity_per_harvest = 1

var quantity

func _ready():
	$Sprite.texture = texture
	$CollisionShape2D.shape.radius = max(texture.get_size().x/2, texture.get_size().y/2)
	quantity = capacity
	$ProgressBar.capacity = capacity
	$ProgressBar.set_current(quantity)
	$ProgressBar.rect_position.y += $Sprite.texture.get_size().y/8

func can_harvest_type(value):
	return type == value

func harvest():
	if quantity > 0:
		quantity -= quantity_per_harvest
		$ProgressBar.set_current(quantity)
		return {
			'type': type,
			'texture': texture,
			'quantity': quantity_per_harvest
		}
