extends MarginContainer

onready var fill = $VBoxContainer/MarginContainer/HBoxContainer/Fill
onready var border = $VBoxContainer/MarginContainer/Border
onready var wave_count = $VBoxContainer/HBoxContainer/WaveCount
onready var last = 0
onready var elapsed = 0

func _ready():
	Globals.connect('elapsed_time_change', self, '_on_Globals_elapsed_time_change')
	Distractions.connect('wave_trigger_change', self, '_on_Distractions_wave_trigger_change')

func _on_Globals_elapsed_time_change():
	elapsed += 1
	print('elapsed: ', elapsed)
	print('border.rect_size.x: ', border.rect_size.x)
	print('Distractions.wave_trigger: ', Distractions.wave_trigger)
	print('last: ', last)
	fill.rect_size.x = ceil(elapsed * border.rect_size.x / (Distractions.wave_trigger - last))

func _on_Distractions_wave_trigger_change():
	last = Globals.elapsed_time
	elapsed = 0
	wave_count.text = str(Distractions.current_wave+1)