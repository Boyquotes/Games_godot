extends Node2D

const ITEM_PATH = "res://Assets/items/"
const WEAPON = {
	"bow": {
		"icon": ITEM_PATH + "bow.png",
		"name": "bow",
		"slot": "WEAPON",
		"dmg": "physical"
	},
	"axe": {
		"icon": ITEM_PATH + "axe.png",
		"name": "axe",
		"slot": "WEAPON"
	},
	"staff": {
		"icon": ITEM_PATH + "staff.png",
		"name": "staff",
		"slot": "WEAPON"
	},
	"wand": {
		"icon": ITEM_PATH + "wand.png",
		"name": "wand",
		"slot": "WEAPON"
	},
	"fire": {
		"icon": ITEM_PATH + "wand.png",
		"name": "fire",
		"slot": "WEAPON"
	}
}

const ARMOR = {
	"1": {
		"id" : "1",
		"name": "gold_chest",
		"icon": ITEM_PATH + "gold_chest.png",
		"type": "str",
		"slot": "CHARACTER",
		"str": 20,
		"int": 10,
		"dex": 10,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 5,
		"poison": 5
	},
	"2": {
		"id": "2",
		"name": "caster_chest",
		"icon": ITEM_PATH + "caster_chest.png",
		"type": "int",
		"slot": "CHARACTER",
		"str": 10,
		"int": 20,
		"dex": 10,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 5,
		"poison": 5
	}
}

func get_item(item_id):
	if item_id in WEAPON:
		return WEAPON[item_id]
	elif item_id in ARMOR:
		return ARMOR[item_id]
	else:
		print("fuckingtrash")
#		return WEAPON["error"]
