extends KinematicBody2D

export (int) var speed = 200
export (int) var fire_wait_time = 0.5
export (int) var mode_switch_time = 1
export (int) var shield_capacity = 0

enum Mode { ATTACK, DODGE }
var mode = Mode.ATTACK
var distance_to_start_dodge_mode = 2000

var target = null

onready var shield_current = shield_capacity
onready var timer = $Timer
onready var shield = $Shield
onready var tween = $Tween

func _ready():
	print('shield_current: ', shield_current)
	Enemies.add_enemy(self)
	reset_timer_wait_time()
	retarget()
	Globals.connect('game_rate_change', self, 'reset_timer_wait_time')
	shield.modulate = Color(1, 1, 1, 0)

func _physics_process(delta):
	var velocity
	if mode == Mode.DODGE: velocity = target
	elif mode == Mode.ATTACK and target and target.get_ref(): velocity = target.get_ref().position - position
	if velocity:
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.is_in_group('player'):
			collision.collider.kill()
			Enemies.remove_enemy(self)

func switch_mode():
	if mode == Mode.ATTACK and in_range_to_dodge(): mode = Mode.DODGE
	else: mode = Mode.ATTACK
	retarget()

func in_range_to_dodge():
	if !target or !target.get_ref(): return false
	return position.distance_to(target.get_ref().position) <= distance_to_start_dodge_mode

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
				leastDistance = node.position.distance_to(position)
			else:
				var distance = node.position.distance_to(position)
				if distance < leastDistance:
					closestNode = node
					leastDistance = distance
	if !closestNode: return null
	else: return weakref(closestNode)

func kill():
	if shield_current <= 0: Enemies.remove_enemy(self)
	else:
		shield_current -= 1
		var before = Color(1, 1, 1, 1.0)
		var after = Color(1, 1, 1, 0.0)
		tween.interpolate_property(shield, 'modulate', before, after, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()

func reset_timer_wait_time():
	timer.wait_time = 1.0 * mode_switch_time / Globals.game_rate
