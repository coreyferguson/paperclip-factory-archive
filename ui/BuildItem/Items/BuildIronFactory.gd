extends Node2D

var collision_layer_mask = 8 | 2048

onready var position_indicator = $ValidPositionIndicator

func _physics_process(delta):
	position_indicator.set_valid(is_valid_position())

func is_valid_position():
	var can_harvest_iron = false
	var nodes = []
	var overlapping_bodies = position_indicator.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		for node in overlapping_bodies:
			if node.has_method('can_harvest_type') and node.can_harvest_type('iron'):
				can_harvest_iron = true
			if node.collision_layer && (node.collision_layer & collision_layer_mask) > 0:
				return false
	var overlapping_areas = position_indicator.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for node in overlapping_areas:
			if node.has_method('can_harvest_type') and node.can_harvest_type('iron'):
				can_harvest_iron = true
			if node.collision_layer && (node.collision_layer & collision_layer_mask) > 0:
				return false
	return can_harvest_iron
