extends Panel

func clear_item():
	$Item.texture = null
	$Quantity.visible = false

func set_item(texture, quantity):

	# texture
	$Item.texture = texture
	var maxDimension = max($Item.texture.get_width(), $Item.texture.get_height())
	var maxAllowed = 30.0
	var scale = maxAllowed / maxDimension
	$Item.scale = Vector2(scale, scale)
	
	#quantity
	$Quantity.text = str(quantity)
	$Quantity.visible = true
