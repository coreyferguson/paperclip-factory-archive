extends StaticBody2D

signal kill

export (int) var capacity = 30
export (int) var harvest_rate = 10
var quantity = 0

var texture = load('res://assets/sun.png')

func _ready():
	buildings.add_building(self)

func _on_Harvester_harvest(node):
	if quantity < capacity:
		var resource = node.harvest()
		if resource: quantity += resource.quantity
	update_progress_bar()

func _on_EnergyToPlayer_player_overlap():
	if quantity >= harvest_rate:
		quantity -= harvest_rate
		inventory.add({
			'type': 'energy',
			'texture': texture,
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
	