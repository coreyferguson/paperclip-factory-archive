extends Node

var map_size

func get_map_size():
	var size
	if map_size: size = map_size
	else:
		var camera = $'/root/Game/Camera'
		size = Vector2(
			camera.limit_right - camera.limit_left, 
			camera.limit_bottom - camera.limit_top
		)
	return size
