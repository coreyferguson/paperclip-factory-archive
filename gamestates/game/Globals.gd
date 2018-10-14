extends Node

signal game_rate_change

# Controls the pace of the game. Speed of ships. Harvest rates. Etc.
# Lower number is slower paced game.
# Higher number is faster paced game.
var game_rate = 1

# World map limits, width and height
var world_size = 20000
var world_size_vector = Vector2(world_size, world_size)

func set_game_rate(value):
	game_rate = value
	emit_signal('game_rate_change')

func reset():
	game_rate = 1