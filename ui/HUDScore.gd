extends MarginContainer

func _ready():
	Score.connect('change', self, 'on_Score_change')
	on_Score_change()
	
func on_Score_change():
	$HBoxContainer/Value.text = str(Score.paperclips)