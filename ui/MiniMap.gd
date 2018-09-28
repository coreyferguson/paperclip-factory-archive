extends NinePatchRect

var blips = {}
var minimap_enemy_blip_resource = load('res://assets/minimap_enemy_blip.png')
var minimap_building_blip_resource = load('res://assets/minimap_building_blip.png')
var minimap_player_blip_resource = load('res://assets/minimap_player_blip.png')
var minimap_screen_boundary_resource = load('res://assets/minimap_screen_boundary.png')
var camera
var player
var rect
var screen_blip
var blip_size = Vector2(10, 10)

func _ready():
	camera = $'/root/Game/Camera'
	player = $'/root/Game/Player'
	rect = $ReferenceRect
	rect.connect('mouse_button_pressed', self, 'mouse_button_pressed')
	# dynamic entities
	enemies.connect('add_enemy', self, 'add_enemy')
	enemies.connect('remove_enemy', self, 'remove_enemy')
	buildings.connect('add_building', self, 'add_building')
	buildings.connect('remove_building', self, 'remove_building')
	# static entities
	track_player()
	track_screen()

func _process(delta):
	for node in blips:
		var blip = blips[node]
		var pos = relative_position_of(node) - blip_size/2
		blip.rect_position = pos
		if pos.y >= 0 and pos.y <= 200 and pos.x >= 0 and pos.x <= 200: blip.visible = true
		else: blip.visible = false
	# screen boundary
	var minimap_size = Vector2(200, 200)
	screen_blip.rect_position = relative_position_of(camera)
	screen_blip.rect_size = OS.window_size * minimap_size / world.get_map_size() * camera.zoom

func mouse_button_pressed(local_position):
	var global_position = global_position_of(local_position)
	var screenSize = OS.get_real_window_size()
	camera.position = global_position - camera.zoom*screenSize/2
	camera.position.x = clamp(camera.position.x, camera.limit_left, camera.limit_right-screenSize.x*camera.zoom.x)
	camera.position.y = clamp(camera.position.y, camera.limit_top, camera.limit_bottom-screenSize.y*camera.zoom.y)

func track_player():
	var blip = TextureRect.new()
	blip.texture = minimap_player_blip_resource
	blip.margin_top = 0
	blip.margin_bottom = 0
	blip.margin_left = 0
	blip.margin_right = 0
	blip.expand = true
	blip.rect_size = blip.texture.get_size()
	blip.rect_position = relative_position_of(player) - blip_size/2
	blips[player] = blip
	rect.add_child(blip)

func track_screen():
	screen_blip = NinePatchRect.new()
	screen_blip.texture = minimap_screen_boundary_resource
	screen_blip.patch_margin_left = 2
	screen_blip.patch_margin_top = 2
	screen_blip.patch_margin_bottom = 2
	screen_blip.patch_margin_right = 2
	screen_blip.rect_size = OS.window_size * rect_size / world.get_map_size()
	rect.add_child(screen_blip)

func add_enemy(enemy):
	var blip = TextureRect.new()
	blip.texture = minimap_enemy_blip_resource
	blip.rect_size = relative_position_of(enemy)
	blips[enemy] = blip
	rect.add_child(blip)

func remove_enemy(enemy):
	if !blips.has(enemy):
		print('Blip does not exist for given entity: ', enemy.get_instance_id())
		return
	var blip = blips[enemy]
	blips.erase(enemy)
	blip.queue_free()
	
func add_building(building):
	var blip = TextureRect.new()
	blip.texture = minimap_building_blip_resource
	blip.rect_size = relative_position_of(building)
	blips[building] = blip
	rect.add_child(blip)

func remove_building(building):
	if blips.has(building):
		var blip = blips[building]
		blips.erase(building)
		blip.queue_free()
	else:
		print('WARNING: Building removed not currently tracked by MiniMap')

func relative_position_of(node):
	# node position relative to world map limits
	var pos_x = node.position.x - camera.limit_left
	var pos_y = node.position.y + camera.limit_bottom
	# node position relative to minimap size
	pos_x = pos_x * rect.rect_size.x / world.get_map_size().x
	pos_y = pos_y * rect.rect_size.y / world.get_map_size().y
	return Vector2(pos_x, pos_y)

func global_position_of(local_position):
	return local_position * world.get_map_size() / rect.rect_size - world.get_map_size()/2
