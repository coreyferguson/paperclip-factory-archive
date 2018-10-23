extends Sprite

onready var position_indicator = $ValidPositionIndicator

func _physics_process(delta):
	position_indicator.set_valid(is_valid_position())

func is_valid_position():
	var can_harvest_iron = false
	var overlapping = position_indicator.get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('can_harvest_type') and node.can_harvest_type('iron'):
				can_harvest_iron = true
			if node.collision_layer && (node.collision_layer & 8) > 0:
				return false
	return can_harvest_iron
