extends MarginContainer

var build_item_hover_requirement_resource = load('res://ui/BuildItem/BuildItemHoverRequirement.tscn')

onready var container = $'MarginContainer/VBoxContainer/RequirementsContainer'
onready var shortcut = $'MarginContainer/VBoxContainer/spacer/HBoxContainer/Shortcut'

func _process(delta):
	rect_position = get_global_mouse_position() + Vector2(50, rect_size.y/-2)
	rect_position.y = clamp(rect_position.y, 0, OS.get_real_window_size().y-rect_size.y-50)

func _on_BuildMenu_hover_in(build_item_type):
	var build_item = Build.Items[build_item_type]
	$MarginContainer/VBoxContainer/Description.text = build_item.description
	var required_resources = get_required_resources(build_item)
	for index in range(required_resources.size()):
		var type = required_resources[index].type
		var quantity = required_resources[index].quantity
		if build_item.hotkey_text: shortcut.text = build_item.hotkey_text
		var build_item_hover_requirement_instance = build_item_hover_requirement_resource.instance()
		build_item_hover_requirement_instance.resource = NaturalResource.types[type].icon
		build_item_hover_requirement_instance.quantity = str(quantity)
		container.add_child(build_item_hover_requirement_instance)
	visible = true

func _on_BuildMenu_hover_out(build_item):
	visible = false
	for child in container.get_children():
		container.remove_child(child)
#	rect_size.x = 0
	rect_size.y = 0

func get_required_resources(build_item):
	if typeof(build_item.required_resources) == TYPE_ARRAY: return build_item.required_resources
	elif typeof(build_item.required_resources) == TYPE_OBJECT: return build_item.required_resources.call_func(Science)
