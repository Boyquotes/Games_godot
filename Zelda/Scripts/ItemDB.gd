extends Node2D

const ITEM_PATH = "res://Assets/items/"
const WEAPON = {
	"bow": {
		"icon": ITEM_PATH + "bow.png",
		"slot": "WEAPON"
	},
	"axe": {
		"icon": ITEM_PATH + "axe.png",
		"slot": "WEAPON"
	},
	"staff": {
		"icon": ITEM_PATH + "staff.png",
		"slot": "WEAPON"
	},
	"wand": {
		"icon": ITEM_PATH + "wand.png",
		"slot": "WEAPON"
	},
	"fire": {
		"icon": ITEM_PATH + "wand.png",
		"slot": "WEAPON"
	}
}

const ARMOUR = {
	"1": {
		"id" : 1,
		"name": "gold_chest",
		"icon": ITEM_PATH + "gold_chest.png",
		"type": "str",
		"slot": "CHARACTER",
		"str": 20,
		"int": 10,
		"dex": 10
	},
	"2": {
		"id": 2,
		"name": "caster_chest",
		"icon": ITEM_PATH + "caster_chest.png",
		"type": "int",
		"slot": "CHARACTER",
		"str": 10,
		"int": 20,
		"dex": 10
	}
}

func get_item(item_id):
	if item_id in WEAPON:
		return WEAPON[item_id]
	elif item_id in ARMOUR:
		return ARMOUR[item_id]
	else:
		print("fuckingtrash")
#		return WEAPON["error"]
