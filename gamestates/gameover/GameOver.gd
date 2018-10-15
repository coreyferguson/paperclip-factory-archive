extends VBoxContainer

var ready_to_end = false
var is_mouse_down = false

onready var reason = $ReasonContainer/ReasonValue
onready var score = $ScoreContainer2/ScoreValue
onready var wave = $WaveContainer/WaveValue

func _ready():
	set_process_input(true)
	reason.text = Globals.game_over_reason
	score.text = str(Score.paperclips)
	wave.text = str(Distractions.current_wave)

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
	Score.reset()
	Inventory.reset()
	Science.reset()
	Distractions.reset()
	Globals.reset()