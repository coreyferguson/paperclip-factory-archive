extends Button

signal build

export (String) var required_item_type
export (int) var required_item_quantity
export (PackedScene) var placement_resource
export (PackedScene) var build_resource

const STATE_DEFAULT = 0
const STATE_CHOOSE_LOCATION = 1
var state = STATE_DEFAULT
var to_be_built = null
var position_valid_resource = load('res://ui/ValidPositionIndicator.tscn')
var position_valid_instance

var game
var camera

func _ready():
	game = $'/root/Game'
	camera = $'/root/Game/Camera'
	_on_Timer_timeout()

func _on_Timer_timeout():
	var quantity = 0
	for item in inventory.items:
		if item != null and item.type == required_item_type: 
			quantity = item.quantity
	if quantity >= required_item_quantity: visible = true
	else: visible = false

func _on_BuildItem_pressed():
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
				if is_valid:
					var instance = build_resource.instance()
					instance.position = get_global_mouse_position() + camera.position
					inventory.remove(required_item_type, required_item_quantity)
					game.add_child(instance)
			to_be_built.queue_free()
			to_be_built = null
			position_valid_instance.queue_free()
			position_valid_instance = null
			state = STATE_DEFAULT

func checkValidPosition():
	var nodes = position_valid_instance.get_overlapping_bodies()
	position_valid_instance.set_valid(nodes.size() == 0)
