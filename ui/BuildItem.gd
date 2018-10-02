tool
extends Button

signal build
signal hover_in(build_item)
signal hover_out(build_item)
signal state_change(state)

export (String) var build_item_type

# Singletons
var Build
var Inventory

# Root Nodes
var game
var camera
var player

# Internal
var build_item
const STATE_DEFAULT = 0
const STATE_CHOOSE_LOCATION = 1
var state = STATE_DEFAULT
var to_be_built = null
var position_valid_resource = load('res://ui/ValidPositionIndicator.tscn')
var position_valid_instance
var build_delivery_resource = load('res://gameplay/BuildDelivery.tscn')
var has_required_items = false
var is_disabled_externally = false

func _ready():
	Build = tool_safe_load('/root/Build', 'res://gamestates/game/Build.gd')
	Inventory = tool_safe_load('/root/Inventory', 'res://gamestates/game/Inventory.gd')
	if !build_item_type: build_item_type = 'AntiShipMine'
	build_item = Build.Items[build_item_type]
	icon = build_item.icon
	if !Engine.editor_hint:
		game = $'/root/Game'
		camera = $'/root/Game/Camera'
		player = $'/root/Game/Player'
		_on_Timer_timeout()

func _process(delta):
	if has_required_items and !is_disabled_externally: disabled = false
	else: disabled = true
	release_focus()

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.scancode == build_item.hotkey:
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
		to_be_built = build_item.placement_resource.instance()
		game.add_child(to_be_built)
		if build_item.has_position_indicator:
			position_valid_instance = position_valid_resource.instance()
			game.add_child(position_valid_instance)

func _unhandled_input(event):
	if state == STATE_CHOOSE_LOCATION:
		if event is InputEventMouseMotion:
			to_be_built.position = get_global_mouse_position()*camera.zoom + camera.position
			if build_item.has_position_indicator:
				position_valid_instance.position = get_global_mouse_position()*camera.zoom + camera.position
				checkValidPosition()
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if build_item.has_position_indicator and position_valid_instance.is_valid(): build()
				if !build_item.has_position_indicator: build()
				get_tree().set_input_as_handled()
			to_be_built.queue_free()
			to_be_built = null
			if build_item.has_position_indicator:
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
	build_delivery_instance.build_resource = build_item.build_resource
	build_delivery_instance.build_position = get_global_mouse_position()*camera.zoom + camera.position
	build_delivery_instance.build_rotation = to_be_built.rotation
	spend_required_items()
	game.add_child(build_delivery_instance)

func has_required_items():
	for required_item in build_item.required_resources:
		var inventory_item = Inventory.get(required_item.type)
		if !inventory_item or inventory_item.quantity < required_item.quantity: return false
	return true

func spend_required_items():
	for required_item in build_item.required_resources:
		Inventory.remove(required_item.type, required_item.quantity)

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

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()
