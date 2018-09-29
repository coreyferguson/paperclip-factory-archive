extends KinematicBody2D

signal kill

export (int) var default_speed = 2
var speed_bonus = 1

var target = null

func _ready():
	recalculate_speed()
	Science.connect('discover', self, '_on_Science_discover')

func _process(delta):
	var speed = default_speed * speed_bonus
	if target != null:
		if position.distance_to(target) < speed:
			position = target
			target = null
		else:
			var velocity = target - position
			velocity = velocity.normalized() * speed
			position += velocity
			rotation = velocity.angle()

func select():
	pass
	
func move_to(position):
	target = position

func kill():
	queue_free()
	emit_signal('kill')

func _on_EnergyTimer_timeout():
	if !Inventory.remove('energy', 1):
		kill()

func _on_Science_discover(discovery, value):
	recalculate_speed()

func recalculate_speed():
	speed_bonus = 1 + (0.1 * Science.discoveries['player_ship_speed'].current_level)
