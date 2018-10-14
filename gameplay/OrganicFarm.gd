extends StaticBody2D

var NaturalResourceStack = load('res://gamestates/game/NaturalResourceStack.gd')

export (int) var capacity = 50
export (int) var harvest_rate = 10
export (int) var conversion_rate = 0.1
export (int) var quantity = 0

func _ready():
	Player.add_building(self)

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
			'texture': NaturalResource.types['organic'].world_texture,
			'quantity': harvest_rate
		})
		update_progress_bar()

func update_progress_bar():
	$ProgressBar.set_current(quantity)

func kill():
	emit_signal('kill')
	Player.remove_building(self)

func recycle():
	var recycled_materials = []
	# recycle build cost
	for resource in Build.Items['OrganicFarm'].required_resources:
		var copy = NaturalResourceStack.new().copy_from(resource)
		copy.quantity = ceil(copy.quantity * 0.8)
		recycled_materials.push_back(copy)
	# recycle gathered organics
	recycled_materials.push_back(NaturalResourceStack.new('organic', floor(quantity)))
	kill()
	return recycled_materials
