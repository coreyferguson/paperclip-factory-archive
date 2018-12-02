extends Node2D

var collision_layer_mask = 8 | 2048

onready var position_indicator = $ValidPositionIndicator

func _physics_process(delta):
	position_indicator.set_valid(is_valid_position())
	var overlapping = position_indicator.get_overlapping_bodies()
	for node in overlapping:
		if node.has_method('can_harvest_type') and node.can_harvest_type('energy'):
			var v = node.global_position - global_position
			rotation = v.angle()

func is_valid_position():
	var can_harvest_energy = false
	var overlapping = position_indicator.get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.has_method('can_harvest_type') and node.can_harvest_type('energy'):
				can_harvest_energy = true
			if node.collision_layer && (node.collision_layer & collision_layer_mask) > 0:
				return false
	var overlapping_areas = position_indicator.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for node in overlapping_areas:
			if node.has_method('can_harvest_type') and node.can_harvest_type('energy'):
				can_harvest_energy = true
			if node.collision_layer && (node.collision_layer & collision_layer_mask) > 0:
				return false
	return can_harvest_energy
