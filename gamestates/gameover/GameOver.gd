extends VBoxContainer

var ready_to_end = false
var is_mouse_down = false

func _ready():
	set_process_input(true)
	$Score.text = 'Score: ' + str(score.get_paperclips())
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed: is_mouse_down = true
		elif is_mouse_down: 
			is_mouse_down = false
			if ready_to_end:
				reset()
				get_tree().change_scene('res://gamestates/title/Title.tscn') 

func _on_Timer_timeout():
	ready_to_end = true

func reset():
	score.reset()
	Inventory.reset()