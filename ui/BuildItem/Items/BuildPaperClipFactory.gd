extends Node2D

onready var position_indicator = $ValidPositionIndicator

func _physics_process(delta):
	var is_valid = is_valid_position()
	position_indicator.set_valid(is_valid)

func is_valid_position():
	var bodies = position_indicator.get_overlapping_bodies()
	var can_harvest_iron = false
	for body in bodies:
		if body.has_method('can_harvest_type') and body.can_harvest_type('iron'):
			can_harvest_iron = true
		if body.collision_layer && (body.collision_layer & 8) > 1:
			return false
	return can_harvest_iron
