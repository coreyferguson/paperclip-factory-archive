extends Button

signal build

export (int) var required_iron = 2

const STATE_DEFAULT = 0
const STATE_CHOOSE_LOCATION = 1
var state = STATE_DEFAULT
var toBeBuilt = null

func _on_Timer_timeout():
	var ironQuantity = 0
	for item in Inventory.items:
		if item != null and item.type == 'iron':
			ironQuantity = item.quantity
	if ironQuantity >= required_iron:
		visible = true
	else:
		visible = false

func _on_Mine_pressed():
	state = STATE_CHOOSE_LOCATION
	toBeBuilt = load('res://gameplay/Mine.tscn').instance()
	add_child(toBeBuilt)

func _unhandled_input(event):
	if state == STATE_CHOOSE_LOCATION:
		if event is InputEventMouseMotion:
			toBeBuilt.position = get_local_mouse_position()
		if event is InputEventMouseButton:
			remove_child(toBeBuilt)
			if event.button_index == BUTTON_LEFT:
				toBeBuilt.position = get_global_mouse_position()
				Inventory.remove('iron', required_iron)
				emit_signal('build', toBeBuilt)
				state = STATE_DEFAULT
				toBeBuilt = null
