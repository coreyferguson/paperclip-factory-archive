tool
extends GridContainer

signal hover_in(build_item)
signal hover_out(build_item)

var build_item_resource = load('res://ui/BuildItem.tscn')

var Build

func _ready():
	Build = tool_safe_load('/root/Build', 'res://gamestates/game/Build.gd')
	for item in Build.Items.values():
		var build_item_instance = build_item_resource.instance()
		build_item_instance.build_item_type = item.type
		add_child(build_item_instance)
	if !Engine.editor_hint:
		for child in get_children():
			child.connect('hover_in', self, '_on_buildItem_hover_in')
			child.connect('hover_out', self, '_on_buildItem_hover_out')
			child.connect('state_change', self, '_on_buildItem_state_change')

func _on_buildItem_hover_in(build_item):
	emit_signal('hover_in', build_item)

func _on_buildItem_hover_out(build_item):
	emit_signal('hover_out', build_item)

func _on_buildItem_state_change(state):
	for child in get_children():
		if state == 'default': child.is_disabled_externally = false
		else: child.is_disabled_externally = true

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()