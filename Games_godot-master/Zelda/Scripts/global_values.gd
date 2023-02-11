extends Node2D

var Player = {
	"player": null,
	"player_xp": 0,
	"player_weapon": null,
	"player_hp": 300,
	"player_lvl": 0,
	"player_pwr": 0,
	"player_move_speed": 3,
	"player_resistance": {"fire": 10, "cold": 10, "lightning": 10, "physical": 10, "poison": 10},
	"player_dmg_types": {"fire": 0, "cold": 0, "lightning": 0, "physical": 0, "poison": 0}
}

var Weapon = {
	"wand_proj": null
}

var Scene = {
	"current_scene": null,
	"next_scene": null,
	"prev_scene": null,
	"portal_spawned": false
}

var Boss = {
	"load_boss": null,
	"boss_type": "",
	"boss_res": {"fire": 50, "cold": 80, "lightning": 50, "physical": 80, "poison": 20},
	"boss_res_modifier": 10,
	"boss_hp_modifier": 500,
	"boss_pwr_modifier": 50
}

var Enemy = {
	"enemy_res_modifier": 10,
	"enemy_dmg_modifier": 80,
	"enemy_resistance": null,
	"enemy_entites": [],
	"enemies": null,
	"enemy_pos": null,
	"enemy_dir": null,
	"enemy_id": 0,
	"enemy_tracker": 0,
	"enemy_hp": 0,
	"enemy_hp_value": 0,
	"enemy_dmg_type": "",
	"all_attack": false,
	"respawn": false
}

var Item = {
	"Item": null,
	"item_id": 0,
	"ilvl": 10,
	"dropped_items": [],
	"inventory_items": [],
	"current_body_armor_id": null,
	"current_weapon_id": null,
	"current_gloves_id": 0,
	"current_boots_id": 0,
	"current_ammo": null,
	"current_ammo_num": 0,
	"quality": 0,
	"quantity": 0	
}

var GUI = {
	"GUI": null,
	"inventory": null,
	"max_mana": 500,
	"poison_stacks": 0,
	"current_mana": 0,
	"coins": 0,
	"add_stats": false,
	"dex": 0,
	"intel": 0,
	"stren": 0
}

var Starting_values = {
	"enemy_hp_value": 50,
	"player_lvl": 0,
	"player_weapon": "1",
	"weapon_power": 50,
	"weapon_damage_type": "physical"
}
