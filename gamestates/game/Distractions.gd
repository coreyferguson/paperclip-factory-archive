extends Node

var current_wave = -1

var scout = load('res://gameplay/Scout.tscn')
var fly = load('res://gameplay/Fly.tscn')
var boomerang = load('res://gameplay/Boomerang.tscn')

var waves = [
	{
		'distractions': [
			{ 'resource': scout, 'quantity': 1 }
		]
	},
	{
		'distractions': [
			{ 'resource': scout, 'quantity': 1 },
			{ 'resource': fly, 'quantity': 1 }
		]
	},
	{
		'distractions': [
			{ 'resource': scout, 'quantity': 4 }
		]
	},
	{
		'distractions': [
			{ 'resource': fly, 'quantity': 6 }
		]
	},
	{
		'distractions': [
			{ 'resource': scout, 'quantity': 8 }
		]
	},
	{
		'distractions': [
			{ 'resource': boomerang, 'quantity': 10 }
		]
	}
]
