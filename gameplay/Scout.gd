extends KinematicBody2D

export (int) var speed = 50
export (bool) var shouldFireMissiles = true
export (int) var missileTimerWaitTime = 20

var target = null

func _ready():
	Enemies.add_enemy(self)
	$MissileTimer.wait_time = missileTimerWaitTime
	if shouldFireMissiles: $MissileTimer.start()
	retarget()
	
func _physics_process(delta):
	if target && target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed * delta
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.is_in_group('player'):
			collision.collider.kill()
			Enemies.remove_enemy(self)

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

func _on_Timer_timeout():
	retarget()

func _on_MissileTimer_timeout():
	if target && target.get_ref():
		var missile = load('res://gameplay/Missile.tscn').instance()
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * $Sprite.texture.get_size()/2
		missile.position = position + velocity
		$'/root/Game'.add_child(missile)

func kill():
	Enemies.remove_enemy(self)
