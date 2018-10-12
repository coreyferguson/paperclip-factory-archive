extends Node

var NaturalResourceStack = load('res://gamestates/game/NaturalResourceStack.gd')

var Items = {
	'AntiMissileMine': {
		'type': 'AntiMissileMine',
		'icon': load('res://assets/player/low-yield-mine_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 1),
			NaturalResourceStack.new('energy', 1)
		],
		'placement_resource': load('res://ui/BuildLowYieldMine.tscn'),
		'build_resource': load('res://gameplay/LowYieldMine.tscn'),
		'hotkey': KEY_N,
		'hotkey_text': 'N',
		'description': 'Anti Missile Mine: Protect yourself from missiles.',
		'has_position_indicator': false,
		'enabled': true
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
		'has_position_indicator': false,
		'enabled': true
	},
	'AntiShipMine3Pack': {
		'type': 'AntiShipMine3Pack',
		'icon': load('res://assets/player/mine-3pack_icon.png'),
		'required_resources': funcref(self, 'AntiShip3PackMineCost'),
		'placement_resource': load('res://ui/BuildMine3Pack.tscn'),
		'build_resource': load('res://gameplay/Mine3Pack.tscn'),
		'hotkey': KEY_3,
		'hotkey_text': '3',
		'description': 'Builds a pack of 3 mines at once.\nRequires science unlock.',
		'has_position_indicator': false,
		'enabled': funcref(self, 'Mine3PackEnabled')
	},
	'PaperclipFactory': {
		'type': 'PaperclipFactory',
		'icon': load('res://assets/player/paperclipfactory_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 15)
		],
		'placement_resource': load('res://ui/BuildPaperClipFactory.tscn'),
		'build_resource': load('res://gameplay/PaperClipFactory.tscn'),
		'hotkey': KEY_P,
		'hotkey_text': 'P',
		'description': 'Paperclip Factory: Get points, but nothing else.',
		'has_position_indicator': true,
		'enabled': true
	},
	'SolarPanel': {
		'type': 'SolarPanel',
		'icon': load('res://assets/player/solar-panel_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 10),
			NaturalResourceStack.new('energy', 10)
		],
		'placement_resource': load('res://ui/BuildSolarPanel.tscn'),
		'build_resource': load('res://gameplay/SolarPanel.tscn'),
		'hotkey': KEY_S,
		'hotkey_text': 'S',
		'description': 'Solar Panel: Harvest and store energy while not present at a sun.',
		'has_position_indicator': true,
		'enabled': true
	},
	'IronFactory': {
		'type': 'IronFactory',
		'icon': load('res://assets/player/ironfactory_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 10),
			NaturalResourceStack.new('energy', 10)
		],
		'placement_resource': load('res://ui/BuildIronFactory.tscn'),
		'build_resource': load('res://gameplay/IronFactory.tscn'),
		'hotkey': KEY_I,
		'hotkey_text': 'I',
		'description': 'Iron Factory: Harvest and store iron while not present at a moon.',
		'has_position_indicator': true,
		'enabled': true
	},
	'DefenseGrid': {
		'type': 'DefenseGrid',
		'icon': load('res://assets/player/defense-grid_icon.png'),
		'required_resources': funcref(self, 'DefenseGridCost'),
		'placement_resource': load('res://ui/BuildDefenseGrid.tscn'),
		'build_resource': load('res://gameplay/DefenseGrid.tscn'),
		'hotkey': KEY_D,
		'hotkey_text': 'D',
		'description': 'Defense Grid will automatically place mines in a limited range.',
		'has_position_indicator': false,
		'enabled': true
	},
	'OrganicFarm': {
		'type': 'OrganicFarm',
		'icon': load('res://assets/player/organic-farm_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 20),
			NaturalResourceStack.new('energy', 20),
			NaturalResourceStack.new('organic', 50)
		],
		'placement_resource': load('res://ui/BuildOrganicFarm.tscn'),
		'build_resource': load('res://gameplay/OrganicFarm.tscn'),
		'hotkey': KEY_B,
		'hotkey_text': 'B',
		'description': 'Organic Farms produce organic material to invest in Science. FOR SCIENCE!\nRequires science unlock.',
		'has_position_indicator': true,
		'enabled': funcref(self, 'OrganicFarmEnabled')
	},
	'Recycler': {
		'type': 'Recycler',
		'icon': load('res://assets/player/recycler_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 5),
			NaturalResourceStack.new('energy', 5)
		],
		'placement_resource': load('res://ui/BuildRecycler.tscn'),
		'build_resource': load('res://gameplay/Recycler.tscn'),
		'hotkey': KEY_R,
		'hotkey_text': 'R',
		'description': 'Recycle structures within a given area.',
		'has_position_indicator': false,
		'enabled': true
	}
}

func AntiShipMineCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	return [ NaturalResourceStack.new('iron', 5 - bonus) ]

func DefenseGridCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	var non_negotiable_cost = 5
	var cost_per_antimissile_mine = 1
	var antimissile_mines = 10
	return [
		NaturalResourceStack.new('iron', non_negotiable_cost + antimissile_mines*cost_per_antimissile_mine),
		NaturalResourceStack.new('energy', antimissile_mines*cost_per_antimissile_mine)
	]

func AntiShip3PackMineCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	return [ NaturalResourceStack.new('iron', 5*3 - 3*bonus) ]

func OrganicFarmEnabled(Science):
	return Science.discoveries['organic_farm'].current_level == 1

func Mine3PackEnabled(Science):
	return Science.discoveries['antiship_mine_3_pack'].current_level == 1
