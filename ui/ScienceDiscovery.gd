tool
extends Control

signal hover_in(discovery_type)
signal hover_out(discovery_type)

export (String) var discovery_type

onready var button = $Button
onready var level = $Level

var Science
var Inventory
var discovery

func _ready():
	Science = tool_safe_load('/root/Science', 'res://gamestates/game/Science.gd')
	Inventory = tool_safe_load('/root/Inventory', 'res://gamestates/game/Inventory.gd')
	Science.connect('discover', self, '_on_Science_discover')
	Inventory.connect('change', self, '_on_Inventory_change')
	if !discovery_type: discovery_type = 'mine_detection_radius'
	discovery = Science.discoveries[discovery_type]
	button.icon = discovery.icon
	check_inventory_requirements()
	update_level_text()

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()

func _process(delta):
	if !Engine.editor_hint:
		button.release_focus()

func _on_Science_discover(type):
	if type == discovery_type: update_level_text()

func _on_Inventory_change():
	check_inventory_requirements()

func _on_Button_pressed():
	Inventory.remove('organic', discovery.cost)
	Science.discover(discovery_type)
	check_inventory_requirements()

func check_inventory_requirements():
	var organic = Inventory.get('organic')
	if !organic or organic.quantity < discovery.cost or discovery.current_level >= discovery.max_level: 
		button.disabled = true
	else: button.disabled = false

func _on_Button_mouse_entered():
	emit_signal('hover_in', discovery_type)

func _on_Button_mouse_exited():
	emit_signal('hover_out', discovery_type)

func update_level_text():
	level.text = str(discovery.current_level)
	