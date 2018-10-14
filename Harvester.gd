extends Area2D

signal harvest(node)

export (String) var type
export (int) var radius = 150
export (int) var harvest_wait_time = 1

onready var timer = $Timer

func _ready():
	$CollisionShape2D.shape.radius = radius
	reset_timer_wait_time()
	timer.start()
	Globals.connect('game_rate_change', self, 'reset_timer_wait_time')

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			var can_harvest_type = false
			if node.has_method('can_harvest_type'): can_harvest_type = node.can_harvest_type(type)
			if node.has_method('harvest') and can_harvest_type: emit_signal('harvest', node)

func reset_timer_wait_time():
	timer.wait_time = 1.0 * harvest_wait_time / Globals.game_rate
