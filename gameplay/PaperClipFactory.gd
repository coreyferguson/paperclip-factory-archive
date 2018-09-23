extends StaticBody2D

signal kill

func _ready():
	buildings.add_building(self)

func _on_Harvester_harvest(node):
	var resource = node.harvest()
	if resource and resource.type == 'iron': score.increment(resource.quantity)

func kill():
	emit_signal('kill')
	buildings.remove_building(self)