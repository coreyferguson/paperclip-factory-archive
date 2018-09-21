extends Container

var radar_pointer_resource = load('res://ui/RadarPointer.tscn')
var camera
var blips = {}

func _ready():
	camera = $'/root/Game/Camera'
	enemies.connect('add_enemy', self, '_on_add_enemy')
	enemies.connect('remove_enemy', self, '_on_remove_enemy')
	
func _on_add_enemy(enemy):
	var blip = radar_pointer_resource.instance()
	add_child(blip)
	blips[enemy] = blip

func _on_remove_enemy(enemy):
	if blips.has(enemy): 
		blips[enemy].queue_free()
		blips.erase(enemy)
	
func _process(delta):
	rect_size = OS.window_size
	rect_position = Vector2(0, 0)
	var centerOfScreen = OS.window_size/2
	var radar_mid = rect_size/2
	for enemy in blips:
		if !weakref(enemy).get_ref(): continue
		var blip = blips[enemy]
		var relative_pos = enemy.position - camera.position - centerOfScreen
		if relative_pos.length() <= min(rect_size.x/2, rect_size.y/2): blip.visible = false
		else: blip.visible = true
		relative_pos = relative_pos.normalized()*radar_mid
		blip.position = radar_mid + relative_pos
		blip.rotation = relative_pos.angle()
