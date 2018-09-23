extends Node

export (bool) var should_generate_worlds = true
var resource_provider_resource = load('res://gameplay/ResourceProvider.tscn')
var world_chunk_size = 1000

func _ready():
	if should_generate_worlds:
		var rows = floor(world.get_map_size().y / world_chunk_size)
		var cols = floor(world.get_map_size().x / world_chunk_size)
		for row in range(rows):
			for col in range(cols):
				var random_resource = resource.get_random()
				var inst = resource_provider_resource.instance()
				inst.type = random_resource.type
				inst.texture = random_resource.world_texture
				inst.capacity = random_resource.initial_capacity
				inst.quantity_per_harvest = random_resource.harvest_rate
				inst.position = get_random_position(col, row)
				add_child(inst)

func get_random_position(col, row):
	randomize()
	var x = col*world_chunk_size + world_chunk_size/2
	x += randi()%world_chunk_size/2 - world_chunk_size/4
	var y = row*world_chunk_size + world_chunk_size/2
	y += randi()%world_chunk_size/2 - world_chunk_size/4
	return Vector2(x, y) - world.get_map_size()/2
