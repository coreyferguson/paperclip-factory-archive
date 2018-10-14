tool
extends Control

export (Vector2) var size = Vector2(100, 10)
export (int) var capacity = 100
export (int) var current = 100

func _ready():
	rect_size = size
	$Fill.rect_size = size
	$Border.rect_size = size
	rect_pivot_offset = size/2
	set_current(current)

func set_current(value):
	current = value
	var max_width = $Border.rect_size.x
	var width = current * max_width / capacity
	$Fill.rect_size.x = width
