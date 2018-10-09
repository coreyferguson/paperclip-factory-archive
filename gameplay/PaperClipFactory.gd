extends StaticBody2D

signal kill

var NaturalResourceStack = load('res://gamestates/game/NaturalResourceStack.gd')

var production_bonus

func _ready():
	buildings.add_building(self)
	recalculation_production_bonus()
	Science.connect('discover', self, '_on_Science_discover')

func _on_Harvester_harvest(node):
	var resource = node.harvest()
	if resource and resource.type == 'iron': 
		score.increment((resource.quantity * production_bonus))

func kill():
	emit_signal('kill')
	buildings.remove_building(self)

func _on_Science_discover(discovery):
	recalculation_production_bonus()

func recalculation_production_bonus():
	production_bonus = 1 + Science.discoveries['paperclip_production_rate'].current_level

func recycle():
	var recycled_materials = []
	for resource in get_required_resources():
		var copy = NaturalResourceStack.new().copy_from(resource)
		copy.quantity = ceil(copy.quantity * 0.8)
		recycled_materials.push_back(copy)
	kill()
	return recycled_materials

func get_required_resources():
	var required_resources = Build.Items['PaperclipFactory'].required_resources
	if typeof(required_resources) == TYPE_OBJECT: required_resources = required_resources.call_func(Science)
	return required_resources