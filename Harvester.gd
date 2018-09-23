extends Area2D

signal harvest(node)

export (String) var type
export (int) var radius = 150

func _ready():
	$CollisionShape2D.shape.radius = radius

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			var can_harvest_type = false
			if node.has_method('can_harvest_type'): can_harvest_type = node.can_harvest_type(type)
			if node.has_method('harvest') and can_harvest_type: emit_signal('harvest', node)
