tool
extends StaticBody2D

export (String) var resource_type = 'iron'
var natural_resource

var NaturalResource

var quantity

func _ready():
	NaturalResource = tool_safe_load('/root/NaturalResource', 'res://gamestates/game/NaturalResource.gd')

func _process(delta):
	if !natural_resource or natural_resource.type != resource_type:
		natural_resource = NaturalResource.types[resource_type]
		refresh()

func can_harvest_type(value):
	return natural_resource.type == value

func harvest():
	if quantity > 0:
		quantity -= natural_resource.harvest_rate
		$ProgressBar.set_current(quantity)
		return {
			'type': natural_resource.type,
			'texture': natural_resource.world_texture,
			'quantity': natural_resource.harvest_rate
		}

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()

func refresh():
	$Sprite.texture = natural_resource.world_texture
	$CollisionShape2D.shape.radius = max(natural_resource.world_texture.get_size().x/2, natural_resource.world_texture.get_size().y/2)
	quantity = natural_resource.initial_capacity
	$ProgressBar.capacity = natural_resource.initial_capacity
	$ProgressBar.set_current(quantity)
	$ProgressBar.rect_position.y += $Sprite.texture.get_size().y/8