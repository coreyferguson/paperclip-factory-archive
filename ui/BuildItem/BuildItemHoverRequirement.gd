tool

extends HBoxContainer

export (Texture) var resource
export (int) var quantity

func _ready():
	$TextureRect.texture = resource
	$Label.text = str(quantity)
