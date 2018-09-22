extends Node

var resource = {
	'iron': {
		'icon': load('res://assets/moon_icon.png')
	},
	'energy': {
		'icon': load('res://assets/sun_icon.png')
	}
}

func get(type):
	return resource[type]
