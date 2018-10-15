extends Node

signal game_rate_change
signal elapsed_time_change

var game_over_reason

# Controls the pace of the game. Speed of ships. Harvest rates. Etc.
# Lower number is slower paced game.
# Higher number is faster paced game.
var game_rate = 1

# Seconds since game started, adjusted for game_rate.
var elapsed_time = 0

# World map limits, width and height
var world_size = 20000
var world_size_vector = Vector2(world_size, world_size)

func set_game_rate(value):
	game_rate = value
	emit_signal('game_rate_change')

func increment_elapsed_time():
	elapsed_time += 1
	emit_signal('elapsed_time_change')

func game_over(reason):
	game_over_reason = reason
	get_tree().change_scene('res://gamestates/gameover/GameOver.tscn')

func reset():
	game_rate = 1