extends Node

const PWR_UP = {
	"0": {
		"name": "speed_up",
		"base": 1,
		"effect": "Globals.player.move_speed"
	},
	"1": {
		"name": "hp_up",
		"base": 10,
		"effect": "Globals.player_hp"
		},
	"2": {
		"name": "pwr_up",
		"base": 15,
		"effect": "Globals.player_pwr"
	},
	"3": {
		"name": "gold",
		"base": 20,
		"effect": null
	},
	"4": {
		"name": "mana_reg",
		"base": 0.5, #Player mana_fill_timer
		"effect": null
	},
	"5": {
		"name": "rnd_weapon",
		"base": null, #Globals drop_weapon()
		"effect": null
	},
	"6": {
		"name": "rnd_armor",
		"base": null, #Globals.drop_armor
		"effect": null
	},
	"7": {
		"name": "change_lvl",
		"base": null #Globals.random_scene
	}
}


#func _ready():
#	pass
