extends Node

# should be ordered by increasing probability

var systems = [
	{
		'resource': load('res://gameplay/SystemGenerator/Systems/1earth2iron.tscn'),
		'probability': 0.050
	},
	{
		'resource': load('res://gameplay/SystemGenerator/Systems/3iron.tscn'),
		'probability': 0.325
	},
	{
		'resource': load('res://gameplay/SystemGenerator/Systems/2iron.tscn'),
		'probability': 0.625
	}
]

func get_random_system():
	randomize()
	var r = randf()
	for system in systems:
		if r < system.probability: return system
		else: r -= system.probability
	return systems[systems.size()-1]