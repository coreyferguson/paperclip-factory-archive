extends Panel

var blips = {}
var minimap_enemy_blip_resource = load('res://assets/minimap_enemy_blip.png')
var camera

func _ready():
	camera = $'/root/Game/Camera'
	enemies.connect('add_enemy', self, 'add_enemy')
	enemies.connect('remove_enemy', self, 'remove_enemy')

func _process(delta):
	for enemy in blips:
		var blip = blips[enemy]
		blip.rect_position = relative_position_of(enemy)

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

func relative_position_of(enemy):
	var map_width = camera.limit_right - camera.limit_left
	var pos_x = enemy.position.x - camera.limit_left
	pos_x = pos_x * rect_size.x / map_width
	var map_height = camera.limit_bottom - camera.limit_top
	var pos_y = enemy.position.y + camera.limit_bottom
	pos_y = pos_y * rect_size.y / map_height
	return Vector2(pos_x, pos_y)
