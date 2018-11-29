extends Node

export (int) var block_size = 5000
export (int) var offset = 1000

onready var game = $'/root/Game'
onready var camera = $'/root/Game/Camera'

var systems_cache = {
	Vector2(0,0): true
}

func _process(delta):
	var pos = camera.global_position + camera.zoom * OS.window_size/2
	var block_id = to_block_id(pos)
	for x in range(-2, 2):
		for y in range(-2, 2):
			var block_offset = Vector2(x, y)
			var id = block_id + block_offset
			if !systems_cache.has(id):
				var system_resource = Cosmos.get_random_system().resource
				var system_instance = system_resource.instance()
				system_instance.global_position = to_global_position(id)
				game.add_child(system_instance)
				systems_cache[id] = true

func to_block_id(pos):
	var x = floor((pos.x + offset) / block_size)
	var y = floor((pos.y + offset) / block_size)
	return Vector2(x, y)

# generate a global position, randomly offset a little bit within the block
func to_global_position(block_id):
	var x = block_id.x * block_size
	var y = block_id.y * block_size
	var max_offset = block_size / 3
	randomize()
	x += randi() % max_offset
	y += randi() % max_offset
	return Vector2(x, y)