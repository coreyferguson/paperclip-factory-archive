extends KinematicBody2D

signal kill

var texture_default = load('res://assets/player/player.png')
var texture_moving = load('res://assets/player/player_moving.png')

export (int) var default_speed = 2
var speed_bonus = 1

var target = null

onready var sprite = $Sprite
onready var rotation_tween = $RotationTween

func _ready():
	sprite.texture = texture_default
	recalculate_speed()
	Science.connect('discover', self, '_on_Science_discover')

func _process(delta):
	var speed = default_speed * speed_bonus
	if target != null:
		if position.distance_to(target) < speed:
			position = target
			target = null
			sprite.texture = texture_default
		else:
			var velocity = target - position
			velocity = velocity.normalized() * speed
			position += velocity

func select():
	pass
	
func move_to(position):
	target = position
	sprite.texture = texture_moving
	var velocity = target - self.position
	var delta = velocity.angle() - rotation
	if delta > PI: delta -= 2 * PI
	if delta < PI*-1: delta += 2 * PI
	rotation_tween.interpolate_property(self, 'rotation', rotation, rotation+delta, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	rotation_tween.start()

func kill():
	queue_free()
	emit_signal('kill')

func _on_EnergyTimer_timeout():
	if !Inventory.remove('energy', 1):
		kill()

func _on_Science_discover(discovery):
	recalculate_speed()

func recalculate_speed():
	speed_bonus = 1 + (0.1 * Science.discoveries['player_ship_speed'].current_level)
