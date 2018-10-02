extends Node

var Items = {
	'AntiMissileMine': {
		'type': 'AntiMissileMine',
		'icon': load('res://assets/player/low-yield-mine_icon.png'),
		'required_resources': [
			{ 'type': 'iron', 'quantity': 1 },
			{ 'type': 'energy', 'quantity': 1 }
		],
		'placement_resource': load('res://ui/BuildLowYieldMine.tscn'),
		'build_resource': load('res://ui/BuildLowYieldMine.tscn'),
		'hotkey': KEY_N,
		'hotkey_text': 'N',
		'description': 'Anti Missile Mine: Protect yourself from missiles.',
		'has_position_indicator': false
	},
	'AntiShipMine': {
		'type': 'AntiShipMine',
		'icon': load('res://assets/player/mine_icon.png'),
		'required_resources': funcref(self, 'AntiShipMineCost'),
		'placement_resource': load('res://ui/BuildMine.tscn'),
		'build_resource': load('res://gameplay/Mine.tscn'),
		'hotkey': KEY_M,
		'hotkey_text': 'M',
		'description': 'Anti Ship Mine: Protect yourself from Kamakaze pilots.',
		'has_position_indicator': false
	},
	'PaperclipFactory': {
		'type': 'PaperclipFactory',
		'icon': load('res://assets/player/paperclipfactory_icon.png'),
		'required_resources': [
			{ 'type': 'iron', 'quantity': 15 }
		],
		'placement_resource': load('res://ui/BuildPaperClipFactory.tscn'),
		'build_resource': load('res://gameplay/PaperClipFactory.tscn'),
		'hotkey': KEY_P,
		'hotkey_text': 'P',
		'description': 'Paperclip Factory: Get points, but nothing else.',
		'has_position_indicator': true
	},
	'SolarPanel': {
		'type': 'SolarPanel',
		'icon': load('res://assets/player/solar-panel_icon.png'),
		'required_resources': [
			{ 'type': 'iron', 'quantity': 10 },
			{ 'type': 'energy', 'quantity': 10 }
		],
		'placement_resource': load('res://ui/BuildSolarPanel.tscn'),
		'build_resource': load('res://gameplay/SolarPanel.tscn'),
		'hotkey': KEY_S,
		'hotkey_text': 'S',
		'description': 'Solar Panel: Harvest and store energy while not present at a sun.',
		'has_position_indicator': true
	},
	'IronFactory': {
		'type': 'IronFactory',
		'icon': load('res://assets/player/ironfactory_icon.png'),
		'required_resources': [
			{ 'type': 'iron', 'quantity': 10 },
			{ 'type': 'energy', 'quantity': 10 }
		],
		'placement_resource': load('res://ui/BuildIronFactory.tscn'),
		'build_resource': load('res://gameplay/IronFactory.tscn'),
		'hotkey': KEY_I,
		'hotkey_text': 'I',
		'description': 'Iron Factory: Harvest and store iron while not present at a moon.',
		'has_position_indicator': true
	},
	'DefenseGrid': {
		'type': 'DefenseGrid',
		'icon': load('res://assets/player/defense-grid_icon.png'),
		'required_resources': [
			{ 'type': 'iron', 'quantity': 60 },
			{ 'type': 'energy', 'quantity': 10 }
		],
		'placement_resource': load('res://ui/BuildDefenseGrid.tscn'),
		'build_resource': load('res://gameplay/DefenseGrid.tscn'),
		'hotkey': KEY_D,
		'hotkey_text': 'D',
		'description': 'Defense Grid will automatically place mines in a limited range.',
		'has_position_indicator': false
	}
}

func AntiShipMineCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	return [ { 'type': 'iron', 'quantity': 5 - bonus } ]