extends Node

signal discover(discovery_type)

var discoveries = {
	'mine_detection_radius': {
		'type': 'mine_detection_radius',
		'description': 'Mine Detection Radius: +10%',
		'icon': load('res://assets/player/mine_icon.png'),
		'cost': 10,
		'max_level': 10,
		'current_level': 0
	},
	'paperclip_production_rate': {
		'type': 'paperclip_production_rate',
		'description': '2x Paperclip Production Rate',
		'icon': load('res://assets/player/paperclipfactory_icon.png'),
		'cost': 50,
		'max_level': 3,
		'current_level': 0
	},
	'player_ship_speed': {
		'type': 'player_ship_speed',
		'description': 'Player Ship Speed +10%',
		'icon': load('res://assets/player/player_icon.png'),
		'cost': 10,
		'max_level': 10,
		'current_level': 0
	},
	'mine_cost': {
		'type': 'mine_cost',
		'description': 'Anti-Ship Mine Cost -1',
		'icon': load('res://assets/player/mine_icon.png'),
		'cost': 15,
		'max_level': 3,
		'current_level': 0
	},
	'organic_farm': {
		'type': 'organic_farm',
		'description': 'Grow your own free-range humans',
		'icon': load('res://assets/player/organic-farm_icon.png'),
		'cost': 50,
		'max_level': 1,
		'current_level': 0
	},
	'iron_factory_conversion_rate': {
		'type': 'iron_factory_conversion_rate',
		'description': '2x more iron from Iron Factories',
		'icon': load('res://assets/player/ironfactory_icon.png'),
		'cost': 30,
		'max_level': 1,
		'current_level': 0
	}
}

func discover(discovery_type):
	discoveries[discovery_type].current_level += 1
	emit_signal('discover', discovery_type)

func get(discovery_type):
	return discoveries[discovery_type]

func reset():
	for discovery_type in discoveries:
		discoveries[discovery_type].current_level = 0