extends Button

signal build
signal hover_in(build_item)
signal hover_out(build_item)
signal state_change(state)

export (Array, String) var required_item_types
export (Array, int) var required_item_quantities
export (PackedScene) var placement_resource
export (PackedScene) var build_resource
export (int) var hotkey
export (String) var hotkey_text
export (String) var description
export (bool) var has_position_indicator = true

const STATE_DEFAULT = 0
const STATE_CHOOSE_LOCATION = 1
var state = STATE_DEFAULT
var to_be_built = null
var position_valid_resource = load('res://ui/ValidPositionIndicator.tscn')
var position_valid_instance
var build_delivery_resource = load('res://gameplay/BuildDelivery.tscn')
var has_required_items = false
var is_disabled_externally = false

var game
var camera
var player

func _ready():
	game = $'/root/Game'
	camera = $'/root/Game/Camera'
	player = $'/root/Game/Player'
	_on_Timer_timeout()

func _process(delta):
	if has_required_items and !is_disabled_externally: disabled = false
	else: disabled = true
	release_focus()

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.scancode == hotkey:
		get_tree().set_input_as_handled()
		choose_location()

func _on_Timer_timeout():
	if has_required_items(): has_required_items = true
	else: has_required_items = false

func _on_BuildItem_pressed():
	choose_location()

func choose_location():
	if state != STATE_CHOOSE_LOCATION and has_required_items():
		set_state(STATE_CHOOSE_LOCATION)
		to_be_built = placement_resource.instance()
		game.add_child(to_be_built)
		if has_position_indicator:
			position_valid_instance = position_valid_resource.instance()
			game.add_child(position_valid_instance)

func _unhandled_input(event):
	if state == STATE_CHOOSE_LOCATION:
		if event is InputEventMouseMotion:
			to_be_built.position = get_global_mouse_position() + camera.position
			if has_position_indicator:
				position_valid_instance.position = get_global_mouse_position() + camera.position
				checkValidPosition()
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if has_position_indicator and position_valid_instance.is_valid(): build()
				if !has_position_indicator: build()
				get_tree().set_input_as_handled()
			to_be_built.queue_free()
			to_be_built = null
			if has_position_indicator:
				position_valid_instance.queue_free()
				position_valid_instance = null
			set_state(STATE_DEFAULT)

func checkValidPosition():
	var to_be_built_valid = true
	if to_be_built.has_method('is_valid_position'): to_be_built_valid = to_be_built.is_valid_position()
	var nodes = position_valid_instance.get_overlapping_bodies()
	position_valid_instance.set_valid(nodes.size() == 0 && to_be_built_valid)

func build():
	var build_delivery_instance = build_delivery_resource.instance()
	build_delivery_instance.position = player.position
	build_delivery_instance.build_resource = build_resource
	build_delivery_instance.build_position = get_global_mouse_position() + camera.position
	build_delivery_instance.build_rotation = to_be_built.rotation
	spend_required_items()
	game.add_child(build_delivery_instance)

func has_required_items():
	if !required_item_types: return true
	var required = {}
	for i in range(required_item_types.size()):
		var item = inventory.get(required_item_types[i])
		if !item || item.quantity < required_item_quantities[i]: return false
	return true

func spend_required_items():
	if !required_item_types: return
	for i in range(required_item_types.size()):
		inventory.remove(required_item_types[i], required_item_quantities[i])

func _on_BuildItem_mouse_entered():
	emit_signal('hover_in', self)

func _on_BuildItem_mouse_exited():
	emit_signal('hover_out', self)

func set_state(value):
	state = value
	var string_value
	if value == STATE_DEFAULT: string_value = 'default'
	elif value == STATE_CHOOSE_LOCATION: string_value = 'choose_location'
	emit_signal('state_change', string_value)