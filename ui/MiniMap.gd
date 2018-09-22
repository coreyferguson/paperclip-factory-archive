extends NinePatchRect

var blips = {}
var minimap_enemy_blip_resource = load('res://assets/minimap_enemy_blip.png')
var minimap_building_blip_resource = load('res://assets/minimap_building_blip.png')
var minimap_player_blip_resource = load('res://assets/minimap_player_blip.png')
var camera
var player

func _ready():
	camera = $'/root/Game/Camera'
	player = $'/root/Game/Player'
	enemies.connect('add_enemy', self, 'add_enemy')
	enemies.connect('remove_enemy', self, 'remove_enemy')
	buildings.connect('add_building', self, 'add_building')
	buildings.connect('remove_building', self, 'remove_building')
	track_player()

func _process(delta):
	for node in blips:
		var blip = blips[node]
		var pos = relative_position_of(node)
		blip.rect_position = pos
		blip.rect_rotation = node.rotation
		if pos.y >= 0 and pos.y <= 200 and pos.x >= 0 and pos.x <= 200: blip.visible = true
		else: blip.visible = false
	
func track_player():
	var blip = TextureRect.new()
	blip.texture = minimap_player_blip_resource
	blip.rect_size = relative_position_of(player)
	blips[player] = blip
	add_child(blip)

func add_enemy(enemy):
	var blip = TextureRect.new()
	blip.texture = minimap_enemy_blip_resource
	blip.rect_size = relative_position_of(enemy)
	blips[enemy] = blip
	add_child(blip)

func remove_enemy(enemy):
	var blip = blips[enemy]
	blips.erase(enemy)
	blip.queue_free()
	
func add_building(building):
	var blip = TextureRect.new()
	blip.texture = minimap_building_blip_resource
	blip.rect_size = relative_position_of(building)
	blips[building] = blip
	add_child(blip)

func remove_building(building):
	var blip = blips[building]
	blips.erase(building)
	blip.queue_free()

func relative_position_of(enemy):
	# world map size
	var map_width = camera.limit_right - camera.limit_left
	var map_height = camera.limit_bottom - camera.limit_top
	# enemy position relative to world map limits
	var pos_x = enemy.position.x - camera.limit_left
	var pos_y = enemy.position.y + camera.limit_bottom
	# enemy position relative to minimap size
	pos_x = pos_x * rect_size.x / map_width
	pos_y = pos_y * rect_size.y / map_height
	# minimap buffer
	pos_x += 15
	pos_y += 15
	return Vector2(pos_x, pos_y)
