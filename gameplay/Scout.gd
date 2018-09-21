extends KinematicBody2D

export (int) var speed = 1
export (bool) var shouldFireMissiles = true
export (int) var missileTimerWaitTime = 20

var target = null

func _ready():
	$MissileTimer.wait_time = missileTimerWaitTime
	if shouldFireMissiles: $MissileTimer.start()
	retarget()
	
func _physics_process(delta):
	if target && target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.has_method('kill'):
			collision.collider.kill()
			enemies.remove_enemy(self)

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

func retarget():
	if target and target.get_ref():
		target.get_ref().disconnect('kill', self, 'on_target_killed')
	target = get_closest_player_node()
	if !target || !target.get_ref(): enemies.remove_enemy(self)
	else: listen_to_target_killed(target)

func _on_Timer_timeout():
	retarget()

func _on_MissileTimer_timeout():
	if target && target.get_ref():
		var missile = load('res://gameplay/Missile.tscn').instance()
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * $Sprite.texture.get_size()/2
		missile.position = position + velocity
		$'/root/Game'.add_child(missile)

func listen_to_target_killed(target):
	target.get_ref().connect('kill', self, 'on_target_killed')

func on_target_killed():
	retarget()

func kill():
	enemies.remove_enemy(self)