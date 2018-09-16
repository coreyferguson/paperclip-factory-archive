extends MarginContainer

func _ready():
	score.connect('change', self, 'on_score_change')
	on_score_change()
	
func on_score_change():
	$HBoxContainer/Value.text = str(score.get_paperclips())