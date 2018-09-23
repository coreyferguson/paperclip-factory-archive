extends KinematicBody2D

export (int) var speed = 5

var target

func _ready():
	retarget()

func _process(delta):
	if target and target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.has_method('kill'):
			collision.collider.kill()
			queue_free()

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
	
func listen_to_target_killed(target):
	target.get_ref().connect('kill', self, 'on_target_killed')

func on_target_killed():
	retarget()

func kill():
	queue_free()

func retarget():
	target = get_closest_player_node()
	if target: listen_to_target_killed(target)

func _on_Timer_timeout():
	retarget()
