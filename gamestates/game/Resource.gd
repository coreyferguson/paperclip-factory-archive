extends Node

var resource = {
	'iron': {
		'type': 'iron',
		'icon': load('res://assets/moon_icon.png'),
		'world_texture': load('res://assets/moon.png'),
		'initial_capacity': 5000,
		'harvest_rate': 1
	},
	'energy': {
		'type': 'energy',
		'icon': load('res://assets/sun_icon.png'),
		'world_texture': load('res://assets/sun.png'),
		'initial_capacity': 10000,
		'harvest_rate': 3
	}
}

func get(type):
	return resource[type]

func get_random():
	randomize()
	return resource.values()[randi() % resource.size()]