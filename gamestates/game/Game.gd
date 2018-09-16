extends Node

func _on_Player_kill():
	get_tree().change_scene('res://gamestates/gameover/GameOver.tscn')
