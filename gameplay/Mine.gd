extends KinematicBody2D

export (int) var speed = 10
export (int) var default_detection_radius = 150

var target

func _ready():
	var bonus = 1+(0.1 * Science.discoveries['mine_detection_radius'].current_level)
	$Detector.set_radius(default_detection_radius * bonus)
	Science.connect('discover', self, '_on_Science_discover')

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

func _on_Science_discover(discovery, value):
	var bonus = 1+(0.1 * Science.discoveries['mine_detection_radius'].current_level)
	$Detector.set_radius(default_detection_radius * bonus)