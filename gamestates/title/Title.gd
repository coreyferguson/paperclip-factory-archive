extends VBoxContainer

var is_mouse_down = false

func _ready():
	set_process_input(true)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			is_mouse_down = true
		elif is_mouse_down:
			is_mouse_down = false
			get_tree().change_scene('res://gamestates/game/Game.tscn')
