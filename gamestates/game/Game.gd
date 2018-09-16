extends Node

func _ready():
	inventory.reset()
	score.reset()

func _on_HUD_build(node):
	node.position += $InputControl/Camera.position
	$'/root/Game'.add_child(node)

func _on_Player_kill():
	get_tree().change_scene('res://gamestates/gameover/GameOver.tscn')
