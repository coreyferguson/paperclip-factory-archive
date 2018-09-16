extends Button

signal build

export (String) var required_item_type
export (int) var required_item_quantity
export (PackedScene) var placement_resource
export (PackedScene) var build_resource

const STATE_DEFAULT = 0
const STATE_CHOOSE_LOCATION = 1
var state = STATE_DEFAULT
var toBeBuilt = null

func _ready():
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
	toBeBuilt = placement_resource.instance()
	add_child(toBeBuilt)

func _unhandled_input(event):
	if state == STATE_CHOOSE_LOCATION:
		if event is InputEventMouseMotion:
			toBeBuilt.position = get_local_mouse_position()
		if event is InputEventMouseButton:
			remove_child(toBeBuilt)
			if event.button_index == BUTTON_LEFT:
				var is_valid = true
				if toBeBuilt.has_method('is_valid_position'): is_valid = toBeBuilt.is_valid_position()
				if is_valid:
					var resource = build_resource.instance()
					resource.position = get_global_mouse_position()
					inventory.remove(required_item_type, required_item_quantity)
					emit_signal('build', resource)
					state = STATE_DEFAULT
					toBeBuilt = null
