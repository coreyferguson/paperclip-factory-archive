extends KinematicBody2D

var NaturalResourceStack = load('res://gamestates/game/NaturalResourceStack.gd')

export (int) var speed = 500
export (int) var default_detection_radius = 150

var target

func _ready():
	recalculate_detection_radius()
	Science.connect('discover', self, '_on_Science_discover')

func _physics_process(delta):
	if target:
		if !target.get_ref(): target = null
		else:
			var velocity = target.get_ref().position - position
			velocity = velocity.normalized() * speed * delta * Globals.game_rate
			var collision = move_and_collide(velocity)
			if collision and collision.collider.has_method('kill'):
				collision.collider.kill()
				queue_free()

func _on_Detector_detection(node):
	target = weakref(node)

func _on_Science_discover(discovery_type):
	recalculate_detection_radius()

func recalculate_detection_radius():
	var bonus = 1 + (0.1 * Science.discoveries['mine_detection_radius'].current_level)
	$Detector.set_radius(default_detection_radius * bonus)

func recycle():
	var recycled_resources = []
	for resource in get_required_resources():
		var copy = NaturalResourceStack.new().copy_from(resource)
		copy.quantity = ceil(copy.quantity * 0.8)
		recycled_resources.push_back(copy)
	queue_free()
	return recycled_resources

func get_required_resources():
	var required_resources = Build.Items['AntiShipMine'].required_resources
	if typeof(required_resources) == TYPE_OBJECT: required_resources = required_resources.call_func(Science)
	return required_resources

func kill():
	queue_free()
