extends StaticBody2D

signal kill

func _on_Harvester_harvest(node):
	var resource = node.harvest()
	if resource and resource.type == 'iron': score.increment(resource.quantity)

func kill():
	queue_free()
	emit_signal('kill')