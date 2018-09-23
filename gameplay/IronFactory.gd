extends StaticBody2D

signal kill

export (int) var capacity = 30
export (int) var harvest_rate = 10
var quantity = 0

var texture = load('res://assets/moon.png')

func _ready():
	buildings.add_building(self)

func kill():
	emit_signal('kill')
	buildings.remove_building(self)

func _on_Harvester_harvest(node):
	if quantity < capacity:
		var resource = node.harvest()
		if resource: quantity += resource.quantity


func _on_IronToPlayer_player_overlap():
	if quantity >= harvest_rate:
		quantity -= harvest_rate
		inventory.add({
			'type': 'iron',
			'texture': texture,
			'quantity': harvest_rate
		})
