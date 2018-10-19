extends Node

signal wave_trigger_change

var types = {
	'scout': {
		'level': 0,
		'resources': [
			load('res://gameplay/Scout_0.tscn'),
			load('res://gameplay/Scout_1.tscn'),
			load('res://gameplay/Scout_2.tscn')
		]
	},
	'fly': {
		'level': 0,
		'resources': [
			load('res://gameplay/Fly_0.tscn'),
			load('res://gameplay/Fly_1.tscn')
		]
	},
	'boomerang': {
		'level': 0,
		'resources': [
			load('res://gameplay/Boomerang_0.tscn'),
			load('res://gameplay/Boomerang_1.tscn')
		]
	},
	'carrier': {
		'level': 0,
		'resources': [
			load('res://gameplay/Carrier.tscn')
		]
	},
	'bulldozer': {
		'level': 0,
		'resources': [
			load('res://gameplay/Bulldozer.tscn')
		]
	},
	'squad001': {
		'level': 0,
		'resources': [
			load('res://gameplay/squads/Squad001.tscn')
		]
	}
}

var current_wave = -1
var wave_trigger = 10 # target Globals.elapsed_time at which to spawn a wave of distractions
var wave_trigger_increment = 90 # seconds between each wave of distractions

var waves = [
	# Wave 1
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 1 }
		]
	},
	# Wave 2
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 1 },
			{ 'type': 'fly', 'quantity': 1 }
		]
	},
	# Wave 3
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 4 }
		]
	},
	# Wave 4
	{
		'distractions': [
			{ 'type': 'fly', 'quantity': 6 }
		]
	},
	# Wave 5
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 8 }
		]
	},
	# Wave 6
	{
		'distractions': [
			{ 'type': 'boomerang', 'quantity': 10 }
		]
	},
	# Wave 7
	{
		'upgrades': [ 'scout' ], # scouts now fire 2 missiles at once
		'distractions': [
			{ 'type': 'scout', 'quantity': 6 },
			{ 'type': 'fly', 'quantity': 6 }
		]
	},
	
	###############
	# BOSS FIGHT! #
	###############
	
	# Wave 8
	
	{
		'distractions': [
			{ 'type': 'carrier', 'quantity': 1 } # BOSS FIGHT!
		]
	},
	# Wave 9
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 14 }
		]
	},
	# Wave 10
	{
		'upgrades': [ 'fly' ], # introduce fly shields
		'distractions': [
			{ 'type': 'fly', 'quantity': 5 } # 3 hits to kill fly = equivalence to 15 flys last level
		]
	},
	# Wave 11
	{
		'upgrades': ['scout'], # introduce scout shields
		'distractions': [
			{ 'type': 'scout', 'quantity': 6 } # 3 hits to kill scout = equivalence to 18 scouts last level
		]
	},
	# Wave 12
	{
		'upgrades': ['boomerang'], # introduce boomerang shields
		'distractions': [
			{ 'type': 'scout', 'quantity': 3 },
			{ 'type': 'fly', 'quantity': 3 },
			{ 'type': 'boomerang', 'quantity': 3 }
		]
	},
	# Wave 13
	{
		'distractions': [
			{ 'type': 'scout', 'quantity': 5 },
			{ 'type': 'fly', 'quantity': 5 },
			{ 'type': 'boomerang', 'quantity': 5 }
		]
	},
	# Wave 14
	{
		'distractions': [
			{ 'type': 'squad001', 'quantity': 1 },
			{ 'type': 'fly', 'quantity': 5 }
		]
	}
]

func increment_wave_trigger():
	wave_trigger += wave_trigger_increment
	current_wave += 1
	emit_signal('wave_trigger_change')

func reset():
	current_wave = -1
	for i in types:
		types[i].level = 0
