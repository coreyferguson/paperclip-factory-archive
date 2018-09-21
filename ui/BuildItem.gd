extends Button

signal build

export (Array, String) var required_item_types
export (Array, int) var required_item_quantities
export (PackedScene) var placement_resource
export (PackedScene) var build_resource
export (int) var hotkey

const STATE_DEFAULT = 0
const STATE_CHOOSE_LOCATION = 1
var state = STATE_DEFAULT
var to_be_built = null
var position_valid_resource = load('res://ui/ValidPositionIndicator.tscn')
var position_valid_instance
var build_delivery_resource = load('res://gameplay/BuildDelivery.tscn')

var game
var camera
var player

func _ready():
	game = $'/root/Game'
	camera = $'/root/Game/Camera'
	player = $'/root/Game/Player'
	_on_Timer_timeout()

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.scancode == hotkey:
		choose_location()

func _on_Timer_timeout():
	if has_required_items(): visible = true
	else: visible = false

func _on_BuildItem_pressed():
	choose_location()

func choose_location():
	if has_required_items():
		state = STATE_CHOOSE_LOCATION
		to_be_built = placement_resource.instance()
		game.add_child(to_be_built)
		position_valid_instance = position_valid_resource.instance()
		game.add_child(position_valid_instance)

func _unhandled_input(event):
	if state == STATE_CHOOSE_LOCATION:
		if event is InputEventMouseMotion:
			to_be_built.position = get_global_mouse_position() + camera.position
			position_valid_instance.position = get_global_mouse_position() + camera.position
			checkValidPosition()
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				var is_valid = true
				if to_be_built.has_method('is_valid_position'): is_valid = to_be_built.is_valid_position()
				is_valid = is_valid and position_valid_instance.is_valid()
				if is_valid: build()
			to_be_built.queue_free()
			to_be_built = null
			position_valid_instance.queue_free()
			position_valid_instance = null
			state = STATE_DEFAULT

func checkValidPosition():
	var nodes = position_valid_instance.get_overlapping_bodies()
	position_valid_instance.set_valid(nodes.size() == 0)

func build():
	var build_delivery_instance = build_delivery_resource.instance()
	build_delivery_instance.position = player.position
	build_delivery_instance.build_resource = build_resource
	build_delivery_instance.build_position = get_global_mouse_position() + camera.position
	spend_required_items()
	game.add_child(build_delivery_instance)

func has_required_items():
	var required = {}
	for i in range(required_item_types.size()):
		var item = inventory.get(required_item_types[i])
		if !item || item.quantity < required_item_quantities[i]: return false
	return true

func spend_required_items():
	for i in range(required_item_types.size()):
		inventory.remove(required_item_types[i], required_item_quantities[i])