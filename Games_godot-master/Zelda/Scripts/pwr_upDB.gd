extends Node

const pwr_upDB = {
	"0": {
		"name": "speed up",
		"amount": 1,
		"id": 0,
		"type": "move_speed"
	},
	"1": {
		"name": "hp up",
		"id": 1,
		"amount": 10,
		"type": "hp"
		},
	"2": {
		"name": "power up",
		"id": 2,
		"amount": 15,
		"type": "power"
	},
	"3": {
		"name": "gold",
		"id": 3,
		"amount": 20,
		"type": "coins",
	},
	"4": {
		"name": "mana up",
		"id": 4,
		"amount": 20,
		"type": "mana",
	},
	"5": {
		"name": "random weapon",
		"id": 5,
		"base": null, #Globals drop_weapon()
		"effect": "somethingWeap"
	},
	"6": {
		"name": "random armor",
		"id": 6,
		"base": null, #Globals.drop_armor
		"effect": "somethingArmor"
	},
	"7": {
		"name": "change next lvl",
		"id": 7,
		"base": "Globals.random_scene()"
	}
}


#func _ready():
#	pass
