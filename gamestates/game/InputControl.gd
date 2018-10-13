extends Node

export (float) var max_zoom_in = 1
export (float) var max_zoom_out = 5
export (float) var zoom_speed = 0.1

var bullet_resource = load('res://gameplay/Bullet.tscn')
var bullet_cost = 2

var is_left_down = false
var is_right_down = false
var left_down_origin
var is_dragging = false
var is_following_player = false

onready var game = $'/root/Game'
onready var camera = $'/root/Game/Camera'
onready var player = $'/root/Game/Player'
onready var hud = $'/root/Game/HUD'

func _process(delta):
	if is_following_player: move_camera_to_player()

func _unhandled_key_input(event):
	handleKeyEvents(event)

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
	
	# mouse scroll wheel
	
	if event is InputEventMouseButton:
		if event.button_index == 5: zoom_out()
		elif event.button_index == 4: zoom_in()

	if is_dragging:
		drag(event)
	elif is_left_click:
		player.move_to(get_global_mouse_position())
	elif is_right_click:
		shoot_bullet(event)

#func leftClick(event):
#	get_tree().set_input_as_handled()
#	var space = get_world_2d().get_direct_space_state();
#	var intersections = space.intersect_point(get_global_mouse_position())
#	var colliders = to_colliders(intersections)
#	if colliders.size() > 0: hud.select(colliders)
#	else: hud.deselect()
#	for collider in colliders:
#		if (collider.has_method('select')): 
#			collider.select()

func drag(event):
	if event is InputEventMouseMotion:
		get_tree().set_input_as_handled()
		camera.position -= event.relative * camera.zoom
		clamp_camera_position()

func handleKeyEvents(event):
	if event is InputEventKey and event.scancode == KEY_SPACE and event.pressed: is_following_player = true
	else: is_following_player = false

func to_colliders(intersections):
	var colliders = Array()
	for i in intersections:
		colliders.push_back(i.collider)
	return colliders

func move_camera_to_player():
	var screen_size = OS.get_real_window_size()
	camera.position = player.position - screen_size/2*camera.zoom

func zoom_out():
	if camera.zoom.x < max_zoom_out:
		camera.zoom += Vector2(zoom_speed, zoom_speed)
		camera.position -= OS.window_size/2 * zoom_speed
		clamp_camera_position()

func zoom_in():
	if camera.zoom.x > max_zoom_in:
		camera.zoom -= Vector2(zoom_speed, zoom_speed)
		camera.position += OS.window_size/2 * zoom_speed
		clamp_camera_position()

func clamp_camera_position():
	var window_size = OS.get_real_window_size()
	camera.position.x = clamp(camera.position.x, camera.limit_left, camera.limit_right-window_size.x*camera.zoom.x)
	camera.position.y = clamp(camera.position.y, camera.limit_top, camera.limit_bottom-window_size.y*camera.zoom.y)

func shoot_bullet(event):
	if Inventory.has('energy') and Inventory.get('energy').quantity >= bullet_cost:
		Inventory.remove('energy', bullet_cost)
		var bullet_instance = bullet_resource.instance()
		bullet_instance.position = player.position
		bullet_instance.velocity = get_global_mouse_position() - player.position
		game.add_child(bullet_instance)
