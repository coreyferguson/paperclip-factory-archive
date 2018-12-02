tool
extends Button

signal build
signal hover_in(build_item_type)
signal hover_out(build_item_type)
signal state_change(state)

export (String) var build_item_type

# Singletons
var Build
var Inventory
var Science

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
var has_required_items_cache = false
var is_disabled_externally = false
var discovered = true

func _ready():
	Build = tool_safe_load('/root/Build', 'res://gamestates/game/Build.gd')
	Inventory = tool_safe_load('/root/Inventory', 'res://gamestates/game/Inventory.gd')
	Science = tool_safe_load('/root/Science', 'res://gamestates/game/Science.gd')
	if !build_item_type: build_item_type = 'AntiShipMine'
	build_item = Build.Items[build_item_type]
	icon = build_item.icon
	check_visibility()
	if !Engine.editor_hint:
		game = $'/root/Game'
		camera = $'/root/Game/Camera'
		player = $'/root/Game/Player'
		_on_Timer_timeout()
		Science.connect('discover', self, '_on_Science_discover')

func _process(delta):
	if has_required_items_cache and !is_disabled_externally and discovered: disabled = false
	else: disabled = true
	release_focus()

func _on_Timer_timeout():
	if has_required_items(): has_required_items_cache = true
	else: has_required_items_cache = false

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		cancel_build()
	if event is InputEventKey and event.pressed and event.scancode == build_item.hotkey:
		get_tree().set_input_as_handled()
		if build_item.skip_choose_location: 
			choose_location()
			build()
			cancel_build()
		else: choose_location()

func _unhandled_input(event):
	if state == STATE_CHOOSE_LOCATION:
		if event is InputEventMouseMotion:
			to_be_built.position = get_mouse_pos()
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT: 
				build()
				get_tree().set_input_as_handled()
			cancel_build()

func can_build():
	var to_be_built_is_valid = true
	if to_be_built and to_be_built.has_method('is_valid_position'): 
		to_be_built_is_valid = to_be_built.is_valid_position()
	var return_val = has_required_items_cache and discovered and to_be_built_is_valid
	return return_val

func can_choose_location():
	return has_required_items_cache and discovered and !is_disabled_externally

func _on_BuildItem_pressed():
	choose_location()

func choose_location():
	if state != STATE_CHOOSE_LOCATION and can_choose_location():
		set_state(STATE_CHOOSE_LOCATION)
		to_be_built = build_item.placement_resource.instance()
		game.add_child(to_be_built)
		to_be_built.position = get_mouse_pos()

func cancel_build():
	if state == STATE_CHOOSE_LOCATION:
		to_be_built.queue_free()
		to_be_built = null
		set_state(STATE_DEFAULT)

func build():
	if can_build():
		var build_delivery_instance = build_delivery_resource.instance()
		build_delivery_instance.position = player.position
		build_delivery_instance.build_item = build_item
		if !build_item:
			print('build item null')
		build_delivery_instance.build_resource = build_item.build_resource
		build_delivery_instance.build_position = get_global_mouse_position()*camera.zoom + camera.position
		if to_be_built: build_delivery_instance.build_rotation = to_be_built.rotation
		spend_required_items()
		game.add_child(build_delivery_instance)

func has_required_items():
	var required_resources
	if typeof(build_item.required_resources) == TYPE_ARRAY: 
		required_resources = build_item.required_resources
	elif typeof(build_item.required_resources) == TYPE_OBJECT: 
		required_resources = build_item.required_resources.call_func(Science)
	for required_item in required_resources:
		var inventory_item = Inventory.get(required_item.type)
		if !inventory_item or inventory_item.quantity < required_item.quantity: return false
	return true

func spend_required_items():
	var required_resources
	if typeof(build_item.required_resources) == TYPE_ARRAY: 
		required_resources = build_item.required_resources
	elif typeof(build_item.required_resources) == TYPE_OBJECT: 
		required_resources = build_item.required_resources.call_func(Science)
	for required_item in required_resources:
		Inventory.remove(required_item.type, required_item.quantity)

func _on_BuildItem_mouse_entered():
	emit_signal('hover_in', build_item_type)

func _on_BuildItem_mouse_exited():
	emit_signal('hover_out', build_item_type)

func set_state(value):
	state = value
	var string_value
	if value == STATE_DEFAULT: string_value = 'default'
	elif value == STATE_CHOOSE_LOCATION: string_value = 'choose_location'
	emit_signal('state_change', string_value)

func check_visibility():
	if typeof(build_item.enabled) == TYPE_BOOL: discovered = build_item.enabled
	elif typeof(build_item.enabled) == TYPE_OBJECT: discovered = build_item.enabled.call_func(Science)

func _on_Science_discover(discovery_type):
	check_visibility()

func get_mouse_pos():
	return get_global_mouse_position()*camera.zoom + camera.position

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()
