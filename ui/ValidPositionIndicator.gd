extends Area2D

var positionValidResource = load('res://assets/ui/position-valid-indicator_300x300.png')
var positionInvalidResource = load('res://assets/ui/position-invalid-indicator_300x300.png')

var valid = true

func set_valid(value):
	valid = value
	if valid: $Sprite.texture = positionValidResource
	else: $Sprite.texture = positionInvalidResource
	
func is_valid():
	return valid
