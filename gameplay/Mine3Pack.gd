extends Node2D

var mine_resource = load('res://gameplay/Mine.tscn')

onready var game = $'/root/Game'
onready var tween = $Tween

func _ready():
	var mine1 = mine_resource.instance()
	var mine2 = mine_resource.instance()
	var mine3 = mine_resource.instance()
	game.add_child(mine1)
	game.add_child(mine2)
	game.add_child(mine3)
	tween.interpolate_property(mine1, 'position', position, Vector2(position.x-5, position.y+35), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(mine2, 'position', position, Vector2(position.x-30, position.y-30), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(mine3, 'position', position, Vector2(position.x+40, position.y-20), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_DequeueTimer_timeout():
	queue_free()
