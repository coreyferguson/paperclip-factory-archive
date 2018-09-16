extends Area2D

signal detection(node)

export (String) var groupDetected
export (int) var radius = 150

func _ready():
	$CollisionShape2D.shape.radius = radius

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node.is_in_group(groupDetected):
				emit_signal('detection', node)
