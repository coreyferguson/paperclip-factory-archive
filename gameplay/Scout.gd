extends KinematicBody2D

export (int) var speed = 50
export (bool) var should_fire_missiles = true
export (int) var missile_timer_wait_time = 20
export (int) var missile_count = 2

var missile_resource = load('res://gameplay/Missile.tscn')

var target = null

onready var game = $'/root/Game'
onready var missile_launchers = $MissileLaunchers
onready var missile_timer = $MissileTimer

func _ready():
	Enemies.add_enemy(self)
	reset_timer_wait_time()
	if should_fire_missiles: missile_timer.start()
	Globals.connect('game_rate_change', self, 'reset_timer_wait_time')
	retarget()
	
func _physics_process(delta):
	if target && target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
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
	if missile_count > 0 and target and target.get_ref():
		for missile_launcher in missile_launchers.get_children():
			if missile_count > 0:
				var missile = missile_resource.instance()
				var origin = missile_launcher.position.rotated(rotation)
				origin = origin.normalized() * 50
				origin += position
				missile.position = origin
				game.add_child(missile)
				missile_count -= 1

func kill():
	Enemies.remove_enemy(self)

func reset_timer_wait_time():
	missile_timer.wait_time = missile_timer_wait_time / Globals.game_rate
