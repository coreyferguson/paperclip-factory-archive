extends KinematicBody2D

export (int) var speed = 150
export (bool) var should_move = true
export (bool) var should_fire_missiles = true
export (int) var missile_timer_wait_time = 20
export (int) var missile_count = 2
export (int) var shield_capacity = 0

var missile_resource = load('res://gameplay/Missile.tscn')
var explosion_resource = load('res://gameplay/Explosion.tscn')
var explosion_texture = load('res://assets/distractions/scout_explosion.png')

onready var shield_current = shield_capacity
onready var game = $'/root/Game'
onready var missile_launchers = $MissileLaunchers
onready var missile_timer = $MissileTimer
onready var shield = $Shield
onready var explosion = $Explosion

# Fade
onready var tween = $Tween
var modulate_off = Color(1, 1, 1, 0.0)
var modulate_on = Color(1, 1, 1, 1.0)

# Target
var target = null
var follow_target = null
var follow_relative_position = null

func _ready():
	Enemies.add_enemy(self)
	reset_timer_wait_time()
	if should_fire_missiles: missile_timer.start()
	Globals.connect('game_rate_change', self, 'reset_timer_wait_time')
	retarget()
	shield.modulate = Color(1, 1, 1, 0)

func _physics_process(delta):
	if !should_move: return
	var velocity
	if follow_target and follow_target.get_ref():
		var target_global_pos = follow_target.get_ref().global_position
		var target_offset = follow_relative_position.rotated(follow_target.get_ref().rotation)
		var new_position = target_global_pos + target_offset
		velocity = new_position - global_position
	elif target and target.get_ref():
		velocity = target.get_ref().global_position - global_position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
	if velocity:
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision:
			if collision.collider.is_in_group('player'):
				collision.collider.kill()
				explode()
			else:
				global_position += collision.remainder

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
				var origin = missile_launcher.global_position.rotated(rotation)
				origin = origin.normalized() * 50
				origin += global_position
				missile.global_position = origin
				game.add_child(missile)
				missile_count -= 1

func kill():
	if shield_current <= 0: explode()
	else:
		shield_current -= 1
		tween.interpolate_property(shield, 'modulate', modulate_on, modulate_off, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()

func explode():
	var explosion = explosion_resource.instance()
	explosion.texture = explosion_texture
	explosion.hframes = 3
	explosion.global_position = global_position
	game.add_child(explosion)
	Enemies.remove_enemy(self)

func reset_timer_wait_time():
	missile_timer.wait_time = missile_timer_wait_time / Globals.game_rate

func follow(node):
	follow_target = weakref(node)
	follow_relative_position = global_position - node.global_position

