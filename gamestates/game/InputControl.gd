extends Node

var is_left_down = false
var is_right_down = false
var left_down_origin
var is_dragging = false

var camera
var player
var hud

func _ready():
	camera = $'/root/Game/Camera'
	player = $'/root/Game/Player'
	hud = $'/root/Game/HUD'

func _unhandled_input(event):
	handleMouseEvents(event)
	
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
		player.move_to(get_global_mouse_position())

func leftClick(event):
	get_tree().set_input_as_handled()
	var space = get_world_2d().get_direct_space_state();
	var intersections = space.intersect_point(get_global_mouse_position())
	var colliders = to_colliders(intersections)
	if colliders.size() > 0: hud.select(colliders)
	else: hud.deselect()
	for collider in colliders:
		if (collider.has_method('select')): 
			collider.select()

func drag(event):
	if event is InputEventMouseMotion:
		get_tree().set_input_as_handled()
		camera.position -= event.relative
		var screenSize = OS.get_real_window_size()
		camera.position.x = clamp(camera.position.x, camera.limit_left, camera.limit_right-screenSize.x)
		camera.position.y = clamp(camera.position.y, camera.limit_top, camera.limit_bottom-screenSize.y)

func to_colliders(intersections):
	var colliders = Array()
	for i in intersections:
		colliders.push_back(i.collider)
	return colliders