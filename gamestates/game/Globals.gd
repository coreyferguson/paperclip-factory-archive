extends Node

# Controls the pace of the game. Speed of ships. Harvest rates. Etc.
# Lower number is slower paced game.
# Higher number is faster paced game.
var game_rate = 0.5

# World map limits, width and height
var world_size = 50000
var world_size_vector = Vector2(world_size, world_size)