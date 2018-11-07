extends Node

var types = {
	'iron': {
		'type': 'iron',
		'icon': load('res://assets/resources/moon_icon.png'),
		'world_texture': load('res://assets/resources/moon.png'),
		'initial_capacity': 5000,
		'harvest_rate': 1
	},
	'energy': {
		'type': 'energy',
		'icon': load('res://assets/resources/sun_icon.png'),
		'world_texture': load('res://assets/resources/sun.png'),
		'initial_capacity': 25000,
		'harvest_rate': 2
	},
	'organic': {
		'type': 'organic',
		'icon': load('res://assets/resources/earth_icon.png'),
		'world_texture': load('res://assets/resources/earth.png'),
		'initial_capacity': 100,
		'harvest_rate': 2
	}
}

func generate():
	randomize()
	var p = rand_range(0, 1)
	for r in types.values():
		if p >= r.probability_range[0] and p < r.probability_range[1]:
			return r
