extends StaticBody2D

signal kill

export (int) var capacity = 30
export (int) var harvest_rate = 10
export (int) var conversion_rate = 0.25
export (int) var quantity = 0

var harvestable_resource_type = 'energy'

func _ready():
	buildings.add_building(self)
	update_progress_bar()

func _on_Harvester_harvest(node):
	if quantity < capacity:
		var resource = node.harvest()
		if resource: quantity += resource.quantity * conversion_rate
	update_progress_bar()

func _on_PlayerDetector_player_overlap():
	if quantity >= harvest_rate:
		quantity -= harvest_rate
		Inventory.add({
			'type': 'energy',
			'texture': NaturalResource.types[harvestable_resource_type].world_texture,
			'quantity': harvest_rate
		})
		update_progress_bar()

func kill():
	emit_signal('kill')
	buildings.remove_building(self)

func update_progress_bar():
	$ProgressBar.set_current(quantity)

func set_sprite_rotation(rotation):
	$Sprite.rotation = rotation
