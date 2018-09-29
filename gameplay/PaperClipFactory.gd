extends StaticBody2D

signal kill

var production_bonus

func _ready():
	buildings.add_building(self)
	recalculation_production_bonus()
	Science.connect('discover', self, '_on_Science_discover')

func _on_Harvester_harvest(node):
	var resource = node.harvest()
	if resource and resource.type == 'iron': score.increment((resource.quantity * production_bonus))

func kill():
	emit_signal('kill')
	buildings.remove_building(self)

func _on_Science_discover(discovery, value):
	recalculation_production_bonus()

func recalculation_production_bonus():
	production_bonus = 1 + Science.discoveries['paperclip_production_rate'].current_level
	print('production_bonus:', production_bonus)