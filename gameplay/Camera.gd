tool
extends Camera2D

var Globals

func _ready():
	Globals = tool_safe_load('/root/Globals', 'res://gamestates/game/Globals.gd')

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()
