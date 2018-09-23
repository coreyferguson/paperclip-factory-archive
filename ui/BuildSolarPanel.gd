extends Area2D

func _physics_process(delta):
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('can_harvest_type') and node.can_harvest_type('energy'):
				var v = node.position - position
				rotation = v.angle()