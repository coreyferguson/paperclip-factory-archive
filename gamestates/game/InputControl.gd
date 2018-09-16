extends Node

var is_left_down = false
var is_right_down = false
var left_down_origin
var is_dragging = false

func _unhandled_input(event):
	handleKeyEvents(event)
	handleMouseEvents(event)
	
func handleKeyEvents(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F11:
		    OS.window_fullscreen = !OS.window_fullscreen
	
func handleMouseEvents(event):
	var is_left_click = false
	var is_right_click = false

	# left click
	if event is InputEventMouseButton and is_left_down and !event.pressed and !is_dragging and event.button_index == BUTTON_LEFT:
		is_left_click = true
	
	# right click
	if event is InputEventMouseButton and is_right_down and !event.pressed and !is_dragging and event.button_index == BUTTON_RIGHT:
		is_right_click = true

	# left down
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		is_left_down = event.pressed
		if event.pressed: left_down_origin = event.position
		if !event.pressed: is_dragging = false
		
	# right down
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		is_right_down = event.pressed

	# start dragging
	if !is_dragging and is_left_down and event is InputEventMouseMotion:
		var magnitude = event.position.distance_to(left_down_origin)
		if magnitude > 25: is_dragging = true

	if is_dragging:
		drag(event)
	elif is_left_click:
		leftClick(event)
	elif is_right_click:
		$Player.move_to(get_global_mouse_position())

func leftClick(event):
	get_tree().set_input_as_handled()
	var space = get_world_2d().get_direct_space_state();
	var intersections = space.intersect_point(get_global_mouse_position())
	var colliders = to_colliders(intersections)
	if colliders.size() > 0: $HUD.select(colliders)
	else: $HUD.deselect()
	for collider in colliders:
		if (collider.has_method('select')): 
			collider.select()

func drag(event):
	if event is InputEventMouseMotion:
		get_tree().set_input_as_handled()
		$Camera.position -= event.relative
		var screenSize = OS.get_real_window_size()
		$Camera.position.x = clamp($Camera.position.x, $Camera.limit_left, $Camera.limit_right-screenSize.x)
		$Camera.position.y = clamp($Camera.position.y, $Camera.limit_top, $Camera.limit_bottom-screenSize.y)

func to_colliders(intersections):
	var colliders = Array()
	for i in intersections:
		colliders.push_back(i.collider)
	return colliders