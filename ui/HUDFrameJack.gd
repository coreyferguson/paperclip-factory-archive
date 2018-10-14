extends MarginContainer

onready var frame_jack = $HBoxContainer/FrameJack

func _ready():
	frame_jack.text = str(Globals.game_rate)

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed:
		var game_rate = Globals.game_rate
		if event.scancode == KEY_KP_ADD: game_rate += 1
		if event.scancode == KEY_KP_SUBTRACT: game_rate -= 1
		game_rate = clamp(game_rate, 1, 10)
		Globals.set_game_rate(game_rate)
		frame_jack.text = str(game_rate)