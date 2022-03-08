extends Node2D

const ITEM_PATH = "res://Assets/items/"
const WEAPON = {
	"1": {
		"id": "1",
		"icon": ITEM_PATH + "bow.png",
		"name": "bow",
		"slot": "WEAPON",
		"pot": 15
	},
	"2": {
		"id": "2",
		"icon": ITEM_PATH + "axe.png",
		"name": "axe",
		"slot": "WEAPON",
		"pot": 20
	},
#	"staff": {
#		"icon": ITEM_PATH + "staff.png",
#		"name": "staff",
#		"slot": "WEAPON",
#		"dmg": "poison",
#		"pot": 20
#	},
	"3": {
		"id": "3",
		"icon": ITEM_PATH + "wand.png",
		"name": "wand",
		"slot": "WEAPON",
		"pot": 5
	},
#	"fire": {
#		"icon": ITEM_PATH + "wand.png",
#		"name": "fire",
#		"slot": "WEAPON",
#		"dmg": "cold",
#		"pot": 20
#	}
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
