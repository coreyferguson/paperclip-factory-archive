extends Area2D

export (int) var radius = 150

func _ready():
	$CollisionShape2D.shape.radius = radius

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('harvest'):
				var resource = node.harvest()
				if resource: inventory.add(resource)
