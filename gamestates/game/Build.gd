extends Node

var NaturalResourceStack = load('res://gamestates/game/NaturalResourceStack.gd')

var Items = {
	'AntiShipMine': {
		'type': 'AntiShipMine',
		'icon': load('res://assets/player/mine_icon.png'),
		'required_resources': funcref(self, 'AntiShipMineCost'),
		'placement_resource': load('res://ui/BuildAntishipMine.tscn'),
		'build_resource': load('res://gameplay/Mine.tscn'),
		'hotkey': KEY_M,
		'hotkey_text': 'M',
		'description': 'Anti Ship Mine: Protect yourself from Kamakaze pilots.',
		'enabled': true,
		'skip_choose_location': true
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
		'enabled': true,
		'skip_choose_location': false
	},
	'SolarPanel': {
		'type': 'SolarPanel',
		'icon': load('res://assets/player/solar-panel_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('energy', 1)
#			NaturalResourceStack.new('iron', 10),
#			NaturalResourceStack.new('energy', 10)
		],
		'placement_resource': load('res://ui/BuildSolarPanel.tscn'),
		'build_resource': load('res://gameplay/SolarPanel.tscn'),
		'hotkey': KEY_S,
		'hotkey_text': 'S',
		'description': 'Solar Panel: Harvest and store energy while not present at a sun.',
		'enabled': true,
		'skip_choose_location': false
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
		'enabled': true,
		'skip_choose_location': false
	},
	'DefenseGrid': {
		'type': 'DefenseGrid',
		'icon': load('res://assets/player/defense-grid_icon.png'),
#		'required_resources': funcref(self, 'DefenseGridCost'),
		'required_resources': [
			NaturalResourceStack.new('energy', 1)
		],
		'placement_resource': load('res://ui/BuildDefenseGrid.tscn'),
		'build_resource': load('res://gameplay/DefenseGrid.tscn'),
		'hotkey': KEY_D,
		'hotkey_text': 'D',
		'description': 'Defense Grid will automatically place mines in a limited range.\nRequires science unlock.',
#		'enabled': funcref(self, 'DefenseGridEnabled'),
		'enabled': true,
		'skip_choose_location': true
	},
	'OrganicFarm': {
		'type': 'OrganicFarm',
		'icon': load('res://assets/player/organic-farm_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 20),
			NaturalResourceStack.new('energy', 20),
			NaturalResourceStack.new('organic', 25)
		],
		'placement_resource': load('res://ui/BuildOrganicFarm.tscn'),
		'build_resource': load('res://gameplay/OrganicFarm.tscn'),
		'hotkey': KEY_O,
		'hotkey_text': 'O',
		'description': 'Organic Farms produce organic material to invest in Science. FOR SCIENCE!\nRequires science unlock.',
		'enabled': funcref(self, 'OrganicFarmEnabled'),
		'skip_choose_location': false
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
		'enabled': true,
		'skip_choose_location': false
	},
	'Freighter': {
		'type': 'Freighter',
		'icon': load('res://assets/player/freighter_icon.png'),
		'required_resources': [
			NaturalResourceStack.new('iron', 5),
			NaturalResourceStack.new('energy', 5)
		],
		'placement_resource': load('res://ui/BuildFreighter.tscn'),
		'build_resource': load('res://gameplay/player/Freighter.tscn'),
		'hotkey': KEY_F,
		'hotkey_text': 'F',
		'description': 'Freighter will collect and transport resources back to you.',
		'enabled': true,
		'skip_choose_location': true
	}
}

func AntiShipMineCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	return [ NaturalResourceStack.new('iron', 5 - bonus) ]

func DefenseGridCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	var required_resources = AntiShipMineCost(Science)
	var antiship_mines = 10
	for resource in required_resources:
		resource.quantity *= 10
	return required_resources

func AntiShip3PackMineCost(Science):
	var bonus = Science.discoveries['mine_cost'].current_level
	return [ NaturalResourceStack.new('iron', 5*3 - 3*bonus) ]

func OrganicFarmEnabled(Science):
	return Science.discoveries['organic_farm'].current_level == 1

func Mine3PackEnabled(Science):
	return Science.discoveries['antiship_mine_3_pack'].current_level == 1

func DefenseGridEnabled(Science):
	return Science.discoveries['defense_grid'].current_level == 1