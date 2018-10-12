tool
extends ParallaxBackground

var Globals

onready var bg = $ParallaxLayer/Background

func _ready():
	Globals = tool_safe_load('/root/Globals', 'res://gamestates/game/Globals.gd')
	bg.region_rect = Rect2(0, 0, Globals.world_size, Globals.world_size)
	bg.offset = Vector2(Globals.world_size/-2, Globals.world_size/-2)
	
func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()