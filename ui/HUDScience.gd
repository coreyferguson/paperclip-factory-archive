tool
extends Control

var science_discovery_resource = load('res://ui/ScienceDiscovery.tscn')

onready var panel = $Panel
onready var view_toggle_button = $ViewToggle
onready var discovery_container = $Panel/MarginContainer/VBoxContainer/MarginContainer/DiscoveryContainer

# hover components
onready var hover = $Hover
onready var hover_description = $Hover/MarginContainer/VBoxContainer/Description
onready var hover_cost = $Hover/MarginContainer/VBoxContainer/HBoxContainer2/Cost
onready var hover_current_level = $Hover/MarginContainer/VBoxContainer/HBoxContainer/CurrentLevel
onready var hover_max_level = $Hover/MarginContainer/VBoxContainer/HBoxContainer/MaxLevel

var Science
var Inventory

func _ready():
	Science = tool_safe_load('/root/Science', 'res://gamestates/game/Science.gd')
	Inventory = tool_safe_load('/root/Inventory', 'res://gamestates/game/Inventory.gd')
	for discovery in Science.discoveries.values():
		var science_discovery_instance = science_discovery_resource.instance()
		science_discovery_instance.discovery_type = discovery.type
		science_discovery_instance.connect('hover_in', self, '_on_ScienceDiscovery_hover_in')
		science_discovery_instance.connect('hover_out', self, '_on_ScienceDiscovery_hover_out')
		discovery_container.add_child(science_discovery_instance)

func _process(delta):
	if !Engine.editor_hint:
		view_toggle_button.release_focus()

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()

func _on_ViewToggle_pressed():
	panel.visible = !panel.visible

func _on_ScienceDiscovery_hover_in(discovery_type):
	var discovery = Science.discoveries[discovery_type]
	hover_description.text = discovery.description
	hover_cost.text = str(discovery.cost)
	hover_current_level.text = str(discovery.current_level)
	hover_max_level.text = str(discovery.max_level)
	hover.visible = true

func _on_ScienceDiscovery_hover_out(discovery_type):
	hover.visible = false