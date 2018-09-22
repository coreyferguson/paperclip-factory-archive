extends ReferenceRect

signal mouse_button_pressed(local_position)

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var pos = get_local_mouse_position()
		if pos.x >= 0 and pos.y >= 0 and pos.x <= rect_size.x and pos.y <= rect_size.y:
			emit_signal('mouse_button_pressed', pos)