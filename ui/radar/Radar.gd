extends Control

var blip_building_resource = load('res://ui/radar/assets/blip_building.png')
var blip_enemy_resource = load('res://ui/radar/assets/blip_enemy.png')
var blip_missile_resource = load('res://ui/radar/assets/blip_missile.png')
var blip_player_bullet_resource = load('res://ui/radar/assets/blip_player_bullet.png')
var screen_boundary_resource = load('res://ui/radar/assets/screen_boundary.png')

var blips = {}
var radar_limit = Globals.radar_radius * 2
var radar_border_size = 10
var screen_blip

onready var rect = $Background/ReferenceRect
onready var rect_position_center = rect.rect_size / 2
onready var player_icon = $PlayerIcon

onready var player = $'/root/Game/Player'
onready var camera = $'/root/Game/Camera'

func _ready():
	Player.connect('add_building', self, 'add_building')
	Player.connect('remove_building', self, 'remove_building')
	Player.connect('add_build_delivery', self, 'add_bullet')
	Player.connect('remove_build_delivery', self, 'remove_bullet')
	Player.connect('add_bullet', self, 'add_bullet')
	Player.connect('remove_bullet', self, 'remove_bullet')
	Enemies.connect('add_enemy', self, 'add_enemy')
	Enemies.connect('remove_enemy', self, 'remove_enemy')
	Enemies.connect('add_missile', self, 'add_missile')
	Enemies.connect('remove_missile', self, 'remove_missile')
	track_screen()

func _process(delta):
	for node in blips:
		var blip = blips[node]
		blip.rect_position = relative_position_of(node)
		var distance = blip.rect_position.distance_to(rect_position_center)
		blip.rect_position -= blip.rect_size/2 # center blip texture
		if distance > rect_position_center.x-radar_border_size: blip.visible = false
		else: blip.visible = true
	# track screen
	screen_blip.rect_position = relative_position_of(camera)
	screen_blip.rect_size = OS.window_size * rect.rect_size / radar_limit * camera.zoom
	var screen_blip_center = screen_blip.rect_position + (screen_blip.rect_size/2.0)
	if screen_blip_center.distance_to(rect_position_center) <= rect_position_center.x: screen_blip.visible = true
	else: screen_blip.visible = false

func relative_position_of(node):
	var d = node.global_position - player.global_position
	var local_position = d * rect.rect_size / radar_limit + rect_position_center
	return local_position

func add_building(building):
	var blip = TextureRect.new()
	blip.texture = blip_building_resource
	blip.rect_position = relative_position_of(building)
	blips[building] = blip
	rect.add_child(blip)

func remove_building(building):
	if !blips.has(building): return
	var blip = blips[building]
	blips.erase(building)
	blip.queue_free()
	
func add_bullet(bullet):
	var blip = TextureRect.new()
	blip.texture = blip_player_bullet_resource
	blip.rect_position = relative_position_of(bullet)
	blips[bullet] = blip
	rect.add_child(blip)

func remove_bullet(bullet):
	if !blips.has(bullet): return
	var blip = blips[bullet]
	blips.erase(bullet)
	blip.queue_free()

func add_enemy(enemy):
	var blip = TextureRect.new()
	blip.texture = blip_enemy_resource
	blip.rect_position = relative_position_of(enemy)
	blips[enemy] = blip
	rect.add_child(blip)

func remove_enemy(enemy):
	if !blips.has(enemy): return
	var blip = blips[enemy]
	blips.erase(enemy)
	blip.queue_free()

func add_missile(missile):
	var blip = TextureRect.new()
	blip.texture = blip_missile_resource
	blip.rect_position = relative_position_of(missile)
	blips[missile] = blip
	rect.add_child(blip)

func remove_missile(missile):
	if !blips.has(missile): return
	var blip = blips[missile]
	blips.erase(missile)
	blip.queue_free()

func track_screen():
	screen_blip = NinePatchRect.new()
	screen_blip.texture = screen_boundary_resource
	screen_blip.patch_margin_left = 2
	screen_blip.patch_margin_top = 2
	screen_blip.patch_margin_bottom = 2
	screen_blip.patch_margin_right = 2
	screen_blip.rect_size = OS.window_size * rect.rect_size / Globals.radar_radius
	rect.add_child(screen_blip)

func _on_ReferenceRect_mouse_button_pressed(local_position):
	if local_position.distance_to(rect_position_center) > rect_position_center.x-radar_border_size: return
	var global_position = global_position_of(local_position)
	camera.global_position = global_position - camera.zoom*OS.window_size/2

func global_position_of(local_position):
	var rect_radius = rect_position_center
	var v = local_position - rect_radius
	var V = Globals.radar_radius * v / rect_radius
	var global_pos = player.global_position + V
	return global_pos
