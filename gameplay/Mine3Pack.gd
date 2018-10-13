extends Node2D

var mine_resource = load('res://gameplay/Mine.tscn')
var spread_radius = 200

onready var game = $'/root/Game'
onready var tween = $Tween

func _ready():
	var mine1 = mine_resource.instance()
	var mine2 = mine_resource.instance()
	var mine3 = mine_resource.instance()
	game.add_child(mine1)
	game.add_child(mine2)
	game.add_child(mine3)
	var p1 = Vector2(0, 1) * spread_radius
	var p2 = p1.rotated(2*PI/3)
	var p3 = p2.rotated(2*PI/3)
	tween.interpolate_property(mine1, 'position', position, p1 + position, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(mine2, 'position', position, p2 + position, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(mine3, 'position', position, p3 + position, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_DequeueTimer_timeout():
	queue_free()
