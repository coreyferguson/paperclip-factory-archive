tool
extends Control

export (String) var discovery_type

onready var current_level_container = $HBoxContainer/VBoxContainer/HBoxContainer/CurrentLevelValue
onready var button = $HBoxContainer/Button
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
	$HBoxContainer/VBoxContainer/Description.text = discovery.description
	$HBoxContainer/VBoxContainer/HBoxContainer2/CostValue.text = str(discovery.cost)
	current_level_container.text = str(discovery.current_level)
	check_inventory_requirements()

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()

func _process(delta):
	if !Engine.editor_hint:
		button.release_focus()

func _on_Science_discover(type):
	if type == discovery_type:
		current_level_container.text = str(discovery.current_level)

func _on_Inventory_change():
	check_inventory_requirements()

func _on_Button_pressed():
	Inventory.remove('organic', discovery.cost)
	Science.discover(discovery_type)

func check_inventory_requirements():
	var organic = Inventory.get('organic')
	if !organic or organic.quantity < discovery.cost: button.disabled = true
	else: button.disabled = false
