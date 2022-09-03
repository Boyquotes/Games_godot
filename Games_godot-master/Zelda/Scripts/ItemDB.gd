extends Node2D

const ITEM_PATH = "res://Assets/items/"
const WEAPON = {
	"1": {
		"id": "1",
		"icon": ITEM_PATH + "bow.png",
		"name": "bow",
		"slot": "WEAPON",
		"power": 15
	},
	"2": {
		"id": "2",
		"icon": ITEM_PATH + "axe.png",
		"name": "axe",
		"slot": "WEAPON",
		"power": 20
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
		"power": 5
	},
#	"fire": {
#		"icon": ITEM_PATH + "wand.png",
#		"name": "fire",
#		"slot": "WEAPON",
#		"dmg": "cold",
#		"pot": 20
#	}
}

const STARTER_ITEMS = {
		"1": {
		"id": "1",
		"name": "starter_chest",
		"icon": ITEM_PATH + "starter_chest.png",
		"type": "normal",
		"slot": "CHARACTER",
		"stren": 10,
		"intel": 10,
		"dex": 10,
		"fire": 10,
		"cold": 10,
		"lightning": 10,
		"physical": 10,
		"poison": 10
	}	
}

const ARMOR = {
	"1": {
		"id" : "1",
		"name": "gold_chest",
		"icon": ITEM_PATH + "gold_chest.png",
		"type": "normal",
		"slot": "CHARACTER",
		"weighting": 0.45,
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
		"type": "normal",
		"slot": "CHARACTER",
		"weighting": 0.45,
		"str": 10,
		"int": 20,
		"dex": 10,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 5,
		"poison": 5
	},
	"3": {
		"id": "3",
		"name": "frog_chest",
		"icon": ITEM_PATH + "frog_chest.png",
		"type": "normal",
		"slot": "CHARACTER",
		"weighting": 0.08,
		"str": 10,
		"int": 10,
		"dex": 30,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 5,
		"poison": 20
	},
	"4": {
		"id": "4",
		"name": "dragon_chest",
		"icon": ITEM_PATH + "dragon_plate_chest.png",
		"type": "boss",
		"slot": "CHARACTER",
		"weighting": 0.02,
		"str": 30,
		"int": 15,
		"dex": 25,
		"fire": 60,
		"cold": 35,
		"lightning": 25,
		"physical": 25,
		"poison": 10
	},
}

const GLOVES = {
	"1": {
		"id": "1",
		"name": "leather_gloves",
		"icon": ITEM_PATH + "gloves_leather.png",
		"type": "normal",
		"slot": "GLOVES",
		"weighting": 0.20,
		"str": 10,
		"int": 2,
		"dex": 10,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 10,
		"poison": 2,
		"special_mod": "attack_speed_up" 
	},
	"2": {
		"id": "2",
		"name": "teal_gloves",
		"icon": ITEM_PATH + "gloves_teal_mage.png",
		"type": "normal",
		"slot": "GLOVES",
		"weighting": 0.20,
		"str": 2,
		"int": 20,
		"dex": 2,
		"fire": 15,
		"cold": 15,
		"lightning": 15,
		"physical": 1,
		"poison": 1,
		"special_mod": "attack_speed_up" 
	},
	"3": {
		"id": "3",
		"name": "hybrid_gloves",
		"icon": ITEM_PATH + "gloves_hybrid_grey.png",
		"type": "normal",
		"slot": "GLOVES",
		"weighting": 0.20,
		"str": 5,
		"int": 5,
		"dex": 5,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 5,
		"poison": 5,
		"special_mod": "attack_speed_up" 
	},
	"4": {
		"id": "4",
		"name": "silver_gloves",
		"icon": ITEM_PATH + "gloves_silver_knight.png",
		"type": "normal",
		"slot": "GLOVES",
		"weighting": 0.20,
		"str": 15,
		"int": 5,
		"dex": 3,
		"fire": 10,
		"cold": 10,
		"lightning": 10,
		"physical": 10,
		"poison": 5,
		"special_mod": "attack_speed_up" 
	},
	"5": {
		"id": "5",
		"name": "purple_gloves",
		"icon": ITEM_PATH + "gloves_purple_knight.png",
		"type": "normal",
		"slot": "GLOVES",
		"weighting": 0.20,
		"str": 10,
		"int": 15,
		"dex": 8,
		"fire": 8,
		"cold": 8,
		"lightning": 8,
		"physical": 10,
		"poison": 15,
		"special_mod": "attack_speed_up" 
	},
}

const BOOTS = {
	"1": {
		"id": "1",
		"name": "leather_boots",
		"icon": ITEM_PATH + "boots_leather.png",
		"type": "normal",
		"slot": "BOOTS",
		"weighting": 0.20,
		"str": 10,
		"int": 10,
		"dex": 10,
		"fire": 5,
		"cold": 5,
		"lightning": 5,
		"physical": 10,
		"poison": 2,
		"special_mod": "attack_speed_up" 
	},
	"2": {
		"id": "2",
		"name": "plate_boots",
		"icon": ITEM_PATH + "boots_knight_plate.png",
		"type": "normal",
		"slot": "BOOTS",
		"weighting": 0.20,
		"str": 15,
		"int": 5,
		"dex": 8,
		"fire": 15,
		"cold": 15,
		"lightning": 15,
		"physical": 20,
		"poison": 2,
		"special_mod": "attack_speed_up" 
	},
	"3": {
		"id": "3",
		"name": "mage_boots",
		"icon": ITEM_PATH + "boots_mage.png",
		"type": "normal",
		"slot": "BOOTS",
		"weighting": 0.20,
		"str": 2,
		"int": 20,
		"dex": 5,
		"fire": 10,
		"cold": 10,
		"lightning": 10,
		"physical": 10,
		"poison": 15,
		"special_mod": "attack_speed_up" 
	},
	"4": {
		"id": "4",
		"name": "leather_green_boots",
		"icon": ITEM_PATH + "boots_leather_green.png",
		"type": "normal",
		"slot": "BOOTS",
		"weighting": 0.20,
		"str": 5,
		"int": 5,
		"dex": 15,
		"fire": 10,
		"cold": 10,
		"lightning": 10,
		"physical": 10,
		"poison": 15,
		"special_mod": "attack_speed_up" 
	},
	"5": {
		"id": "5",
		"name": "leather_boots_yellow",
		"icon": ITEM_PATH + "boots_leather_yellow.png",
		"type": "normal",
		"slot": "BOOTS",
		"weighting": 0.20,
		"str": 2,
		"int": 2,
		"dex": 20,
		"fire": 10,
		"cold": 10,
		"lightning": 15,
		"physical": 10,
		"poison": 5,
		"special_mod": "attack_speed_up" 
	}
}

const BOSS_ARMOR = {
	"1": {
		"id": "1",
		"name": "dragon_chest",
		"icon": ITEM_PATH + "dragon_plate_chest.png",
		"type": "boss",
		"slot": "CHARACTER",
		"str": 30,
		"int": 15,
		"dex": 25,
		"fire": 60,
		"cold": 35,
		"lightning": 25,
		"physical": 25,
		"poison": 10
	}
}

const PWRUP = {
	"1": {
		"id": "1",
		"icon": ITEM_PATH + "pwrup_fire_proj_wand.png",
		"type": "wand_proj",
		"name": "pwrup_fire_proj",
		"slot": "POWERUP"
	},
	"2": {
		"id": "2",
		"icon": ITEM_PATH + "pwrup_all_attack.png",
		"type": "buff",
		"name": "pwrup_all_attack",
		"slot": "POWERUP"
	},
	"3": {
		"id": "3",
		"icon": ITEM_PATH + "pwrup_dmg_up.png",
		"type": "buff",
		"name": "pwrup_dmg_up",
		"slot": "POWERUP"
	},
	"4": {
		"id": "4",
		"icon": ITEM_PATH + "pwrup_health_up.png",
		"type": "buff",
		"name": "pwrup_health_up",
		"slot": "POWERUP"
	},
	"5": {
		"id": "5",
		"icon": ITEM_PATH + "pwrup_invis.png",
		"type": "buff",
		"name": "pwrup_invis",
		"slot": "POWERUP"
	},
	"6": {
		"id": "6",
		"icon": ITEM_PATH + "pwrup_muns.png",
		"type": "muns",
		"name": "pwrup_muns",
		"slot": "POWERUP"
	},
	"7": {
		"id": "7",
		"icon": ITEM_PATH + "pwrup_speed_up.png",
		"type": "buff",
		"name": "pwrup_speed_up",
		"slot": "POWERUP"
	},
	"8": {
		"id": "8",
		"icon": ITEM_PATH + "pwrup_lazor.png",
		"type": "wand_proj",
		"name": "pwrup_lazor_proj",
		"slot": "POWERUP"
	}
	
}

func get_item(item_id):
	if item_id in WEAPON:
		return WEAPON[item_id]
	elif item_id in ARMOR:
		return ARMOR[item_id]
	elif item_id in PWRUP:
		return PWRUP[item_id]
	else:
		print("fuckingtrash")
#		return WEAPON["error"]
