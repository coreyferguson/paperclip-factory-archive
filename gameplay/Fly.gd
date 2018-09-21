extends KinematicBody2D

export (int) var speed = 5
export (int) var fire_wait_time = 0.5
export (int) var mode_switch_time = 1

enum Mode { ATTACK, DODGE }
var mode = Mode.ATTACK

var target = null

func _ready():
	$Timer.wait_time = mode_switch_time
	retarget()
	
func _physics_process(delta):
	var velocity
	if mode == Mode.DODGE: velocity = target
	elif mode == Mode.ATTACK and target and target.get_ref(): velocity = target.get_ref().position - position
	if velocity:
		velocity = velocity.normalized() * speed
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.has_method('kill'):
			collision.collider.kill()
			queue_free()

func switch_mode():
	if mode == Mode.ATTACK: mode = Mode.DODGE
	else: mode = Mode.ATTACK
	retarget()

func retarget():
	if mode == Mode.ATTACK:
		target = get_closest_player_node()
	else:
		target = Vector2(rand_range(-1000, 1000), rand_range(-1000, 1000))

func get_closest_player_node():
	var playerNodes = get_tree().get_nodes_in_group('player')
	var closestNode
	var leastDistance
	for node in playerNodes:
		if !node.is_queued_for_deletion():
			if leastDistance == null:
				closestNode = node
				leastDistance = node.position - position
			else:
				var distance = node.position - position
				if distance < leastDistance:
					closestNode = node
					leastDistance = distance
	if !closestNode: return null
	else: return weakref(closestNode)

func kill():
	queue_free()