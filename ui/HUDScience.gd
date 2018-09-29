tool
extends Control

var science_discovery_resource = load('res://ui/ScienceDiscovery.tscn')

onready var panel = $Panel
onready var bio_compute_value = $Panel/MarginContainer/VBoxContainer/BioComputePower/Value
onready var view_toggle_button = $ViewToggle
onready var discovery_container = $Panel/MarginContainer/VBoxContainer/MarginContainer/DiscoveryContainer

var Science
var Inventory

func _ready():
	Science = tool_safe_load('/root/Science', 'res://gamestates/game/Science.gd')
	Inventory = tool_safe_load('/root/Inventory', 'res://gamestates/game/Inventory.gd')
	for discovery in Science.discoveries.values():
		var science_discovery_instance = science_discovery_resource.instance()
		science_discovery_instance.discovery_type = discovery.type
		discovery_container.add_child(science_discovery_instance)

func _process(delta):
	if !Engine.editor_hint:
		var organic = Inventory.get('organic')
		if organic: bio_compute_value.text = str(organic.quantity)
		else: bio_compute_value.text = '0'
		view_toggle_button.release_focus()

func tool_safe_load(node_path, resource_path):
	if has_node(node_path): return get_node(node_path)
	else: return load(resource_path).new()

func _on_ViewToggle_pressed():
	panel.visible = !panel.visible
