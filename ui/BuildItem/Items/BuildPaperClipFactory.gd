extends Node2D

var collision_layer_mask = 8 | 2048

onready var position_indicator = $ValidPositionIndicator

func _physics_process(delta):
	position_indicator.set_valid(is_valid_position())

func is_valid_position():
	var can_harvest_iron = false
	var bodies = position_indicator.get_overlapping_bodies()
	for body in bodies:
		if body.has_method('can_harvest_type') and body.can_harvest_type('iron'):
			can_harvest_iron = true
		if body.collision_layer && (body.collision_layer & collision_layer_mask) > 1:
			return false
	var areas = position_indicator.get_overlapping_areas()
	for body in areas:
		if body.has_method('can_harvest_type') and body.can_harvest_type('iron'):
			can_harvest_iron = true
		if body.collision_layer && (body.collision_layer & collision_layer_mask) > 1:
			return false
	return can_harvest_iron
