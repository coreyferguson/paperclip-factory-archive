extends Node

var resource = {
	'iron': {
		'type': 'iron',
		'icon': load('res://assets/moon_icon.png'),
		'world_texture': load('res://assets/moon.png'),
		'initial_capacity': 5000,
		'harvest_rate': 1,
		'probability_range': [0, 0.6]
	},
	'energy': {
		'type': 'energy',
		'icon': load('res://assets/sun_icon.png'),
		'world_texture': load('res://assets/sun.png'),
		'initial_capacity': 10000,
		'harvest_rate': 3,
		'probability_range': [0.6, 0.9]
	},
	'organic': {
		'type': 'organic',
		'icon': load('res://assets/earth_icon.png'),
		'world_texture': load('res://assets/earth.png'),
		'initial_capacity': 1000,
		'harvest_rate': 2,
		'probability_range': [0.9, 1]
	}
}

func get(type):
	return resource[type]

func generate():
	randomize()
	var p = rand_range(0, 1)
	for r in resource.values():
		if p >= r.probability_range[0] and p < r.probability_range[1]:
			return r