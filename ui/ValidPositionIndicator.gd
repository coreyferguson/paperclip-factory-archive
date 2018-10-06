extends Area2D

export (int) var radius = 150

var positionValidResource = load('res://assets/ui/position-valid-indicator_300x300.png')
var positionInvalidResource = load('res://assets/ui/position-invalid-indicator_300x300.png')

var valid = true

onready var sprite = $NinePatchRect
onready var collision_shape = $CollisionShape2D

func _ready():
	sprite.rect_size = Vector2(radius*2, radius*2)
	sprite.rect_position = Vector2(radius*-1, radius*-1)
	collision_shape.shape.radius = radius

func set_valid(value):
	valid = value
	if valid: sprite.texture = positionValidResource
	else: sprite.texture = positionInvalidResource
	
func is_valid():
	return valid

