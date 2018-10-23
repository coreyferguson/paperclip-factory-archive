extends Sprite

onready var space = get_world_2d().direct_space_state
var params
var shape

func _ready():
	params = Physics2DShapeQueryParameters.new()
	params.collision_layer = 8
	shape = CircleShape2D.new()
	shape.radius = 900
	params.set_shape(shape)

func is_valid_position():
	params.transform = Transform2D(0, global_position)
	var intersections = space.intersect_shape(params)
	for intersection in intersections:
		var collider = intersection.collider
		if collider.has_method('can_harvest') and collider.can_harvest():
			return true
	return false

