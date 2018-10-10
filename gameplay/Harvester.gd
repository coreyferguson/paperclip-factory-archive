extends Area2D

export (int) var radius = 150
export (int) var harvest_time_seconds = 1

func _ready():
	$CollisionShape2D.shape.radius = radius
	$Timer.wait_time = harvest_time_seconds / Globals.game_rate

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('harvest'):
				var resource = node.harvest()
				if resource: Inventory.add(resource)
