extends Node2D

export (int) var speed = 150

var target

func _ready():
	Enemies.add_enemy(self)

func kill():
	Enemies.remove_enemy(self)

func _physics_process(delta):
	if target and target.get_ref():
		var velocity = target.get_ref().global_position - global_position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.is_in_group('player'):
			collision.collider.kill()
			self.kill()

func get_closest_player_node():
	var playerNodes = get_tree().get_nodes_in_group('player')
	var closestNode
	var leastDistance
	for node in playerNodes:
		if !node.is_queued_for_deletion():
			if leastDistance == null:
				closestNode = node
				leastDistance = node.position.distance_to(position)
			else:
				var distance = node.position.distance_to(position)
				if distance < leastDistance:
					closestNode = node
					leastDistance = distance
	if !closestNode: return null
	else: return weakref(closestNode)

func retarget():
	target = get_closest_player_node()

func _on_RetargetTimer_timeout():
	retarget()
