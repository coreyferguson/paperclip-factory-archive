extends Area2D

export (int) var radius = 150
export (int) var harvest_time_seconds = 1

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
			if node.has_method('harvest'):
				var resource = node.harvest()
				if resource: Inventory.add(resource)

func reset_timer_wait_time():
	timer.wait_time = 1.0 * harvest_time_seconds / Globals.game_rate
	