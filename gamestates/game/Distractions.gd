extends Node

var types = {
	'scout': {
		'level': 0,
		'resources': [
			load('res://gameplay/Scout_0.tscn'),
			load('res://gameplay/Scout_1.tscn')
		]
	},
	'fly': {
		'level': 0,
		'resources': [
			load('res://gameplay/Fly.tscn')
		]
	},
	'boomerang': {
		'level': 0,
		'resources': [
			load('res://gameplay/Boomerang.tscn')
		]
	}
}

var current_wave = -1

var waves = [
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 1 }
		]
	},
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 1 },
			{ 'type': 'fly', 'quantity': 1 }
		]
	},
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 4 }
		]
	},
	{
		'distractions': [
			{ 'type': 'fly', 'quantity': 6 }
		]
	},
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 8 }
		]
	},
	{
		'distractions': [
			{ 'type': 'boomerang', 'quantity': 10 }
		]
	},
	{
		'upgrades': [ 'scout' ],
		'distractions': [
			{ 'type': 'scout', 'quantity': 6 },
			{ 'type': 'fly', 'quantity': 6 }
		]
	}
]
