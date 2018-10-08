tool
extends Area2D

signal detection(node)

export (String) var groupDetected
export (int) var radius = 150

onready var shape = $CollisionShape2D.shape

func _ready():
	$CollisionShape2D.shape.radius = radius
	_on_Timer_timeout()

func _process(delta):
	shape.radius = radius

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if groupDetected:
				if node.is_in_group(groupDetected):
					emit_signal('detection', node)
			else:
				emit_signal('detection', node)

func set_radius(radius):
	$CollisionShape2D.shape.radius = radius
