extends KinematicBody2D

signal kill

export (int) var speed = 2

var target = null

func _process(delta):
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
	if !inventory.remove('energy', 1):
		kill()
