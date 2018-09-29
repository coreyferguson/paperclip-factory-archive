extends Node

signal discover(discovery_type)

var discoveries = {
	'mine_detection_radius': {
		'type': 'mine_detection_radius',
		'description': 'Mine Detection Radius: +10%',
		'cost': 10,
		'max_level': 10,
		'current_level': 0
	},
	'paperclip_production_rate': {
		'type': 'paperclip_production_rate',
		'description': 'Paperclip Production Rate +100%',
		'cost': 50,
		'max_level': 3,
		'current_level': 0
	},
	'player_ship_speed': {
		'type': 'player_ship_speed',
		'description': 'Player Ship Speed +10%',
		'cost': 10,
		'max_level': 10,
		'current_level': 0
	}
}

func discover(discovery_type):
	discoveries[discovery_type].current_level += 1
	emit_signal('discover', discovery_type)

func get(discovery_type):
	return discoveries[discovery_type]
