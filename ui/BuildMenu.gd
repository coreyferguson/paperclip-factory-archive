extends GridContainer

signal build

func _on_BuildItem_build(node):
	emit_signal('build', node)
