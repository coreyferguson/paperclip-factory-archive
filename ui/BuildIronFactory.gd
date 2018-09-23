extends Area2D

func is_valid_position():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('can_harvest_type') and node.can_harvest_type('iron'):
				return true
	return false
