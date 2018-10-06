extends StaticBody2D

signal kill

export (int) var capacity = 100
export (int) var harvest_rate = 10
export (int) var conversion_rate = 0.25

var quantity = 0
var conversion_rate_bonus = 1

var harvestable_resource_type = 'iron'

func _ready():
	buildings.add_building(self)
	Science.connect('discover', self, '_on_Science_discover')

func kill():
	emit_signal('kill')
	buildings.remove_building(self)

func _on_Harvester_harvest(node):
	if quantity < capacity:
		var resource = node.harvest()
		if resource: quantity += resource.quantity * conversion_rate * conversion_rate_bonus
	update_progress_bar()

func _on_IronToPlayer_player_overlap():
	if quantity >= harvest_rate:
		quantity -= harvest_rate
		Inventory.add({
			'type': 'iron',
			'texture': NaturalResource.types[harvestable_resource_type].world_texture,
			'quantity': harvest_rate
		})
		update_progress_bar()

func update_progress_bar():
	$ProgressBar.set_current(quantity)

func recycle():
	var recycled_materials = []
	for resource in Build.Items['IronFactory'].required_resources:
		recycled_materials.push_back(resource)
	kill()
	return recycled_materials

func _on_Science_discover(discovery_type):
	conversion_rate_bonus = 1 + Science.discoveries[discovery_type].current_level
