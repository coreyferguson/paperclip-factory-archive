extends KinematicBody2D

export (int) var speed = 10

var target

func _physics_process(delta):
	if target:
		if !target.get_ref(): target = null
		else:
			var velocity = target.get_ref().position - position
			velocity = velocity.normalized() * speed
			var collision = move_and_collide(velocity)
			if collision and collision.collider.has_method('kill'):
				collision.collider.kill()
				queue_free()

func _on_Detector_detection(node):
	target = weakref(node)
