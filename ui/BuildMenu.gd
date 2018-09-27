extends GridContainer

signal hover_in(build_item)
signal hover_out(build_item)

func _ready():
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
	

