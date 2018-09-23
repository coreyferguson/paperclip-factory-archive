extends ReferenceRect

signal mouse_button_pressed(local_position)

var mouse_pressed = false
var mouse_pressed_in_bounds = false

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var position = get_local_mouse_position()
		if !mouse_pressed and is_in_bounds(position):
			mouse_pressed = true
			mouse_pressed_in_bounds = true
		if mouse_pressed_in_bounds:emit_signal('mouse_button_pressed', position)
		mouse_pressed = true
	else:
		mouse_pressed = false
		mouse_pressed_in_bounds = false

func is_in_bounds(position):
	return position.x >= 0 and position.y >= 0 and position.x <= rect_size.x and position.y <= rect_size.y