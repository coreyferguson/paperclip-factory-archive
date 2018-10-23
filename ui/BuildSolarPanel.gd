extends Sprite

onready var position_indicator = $ValidPositionIndicator

func _physics_process(delta):
	var overlapping = position_indicator.get_overlapping_bodies()
	var can_harvest_energy = false
	var is_overlapping_building = false
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('can_harvest_type') and node.can_harvest_type('energy'):
				can_harvest_energy = true
				var v = node.position - position
				rotation = v.angle()
			if node.collision_layer && (node.collision_layer & 8) > 0:
				is_overlapping_building = true
				break
	position_indicator.set_valid(can_harvest_energy && !is_overlapping_building)

func is_valid_position():
	var can_harvest_energy = false
	var overlapping = position_indicator.get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('can_harvest_type') and node.can_harvest_type('energy'):
				can_harvest_energy = true
			if node.collision_layer && (node.collision_layer & 8) > 0:
				return false
	return can_harvest_energy
