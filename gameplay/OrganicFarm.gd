extends StaticBody2D

export (int) var capacity = 50
export (int) var harvest_rate = 10
export (int) var conversion_rate = 0.25
var quantity = 0

var harvestable_resource_type = 'energy'

func _ready():
	buildings.add_building(self)

func _on_Harvester_harvest(node):
	if quantity < capacity:
		var resource = node.harvest()
		if resource: quantity += resource.quantity * conversion_rate
	update_progress_bar()

func _on_PlayerDetector_player_overlap():
	if quantity >= harvest_rate:
		quantity -= harvest_rate
		Inventory.add({
			'type': 'organic',
			'texture': NaturalResource.types[harvestable_resource_type].world_texture,
			'quantity': harvest_rate
		})
		update_progress_bar()

func update_progress_bar():
	$ProgressBar.set_current(quantity)

func kill():
	emit_signal('kill')
	buildings.remove_building(self)

func recycle():
	var recycled_materials = []
	# recycle build cost
	for resource in Build.Items['OrganicFarm'].required_resources:
		recycled_materials.push_back(resource)
	# recycle gathered organics
	Inventory.add({
		'type': 'organic',
		'texture': NaturalResource.types[harvestable_resource_type].world_texture,
		'quantity': quantity
	})
	kill()
	return recycled_materials
