extends Node2D

var Player = {
	"player": null,
	"player_xp": ""
}

var Scenes = {
	"current_scene": null,
	"next_scene": null,
	"prev_scene": null
}
#
#var player = null
#var current_scene = null
#var next_scene
#var player_spawn_pos = null
#var player_weapon = false
#var starter_weapon = true
#var wand_proj = null
#var player_hp = 300
#var player_xp = 0
#var player_lvl = 0
#var player_pwr = 0
#var player_move_speed = 3
#var player_resistance = {"fire": 10, "cold": 10, "lightning": 10, "physical": 10, "poison": 10}
#var player_dmg_types = {"fire": 0, "cold": 0, "lightning": 0, "physical": 0, "poison": 0}
#var boss_res = {"fire": 50, "cold": 80, "lightning": 50, "physical": 80, "poison": 20}
#var quality = 0
#var quantity = 0
#var boss_res_modifier = 10
#var load_boss
#var enemy_res_modifier = 10
#var enemy_dmg_modifier = 80
#var boss_hp_modifier = 500
#var boss_pwr_modifier = 50
#var portal_spawned = false
#var enemy_resistance
#var damage_type
#var max_mana = 500
#var poison_stacks = 0
#var current_mana
#var coins = 0
#var dex = 0
#var intel = 0
#var stren = 0
#var player_attack = false
#var inventory
#var Items
#var item
#var item_id = 0
#var ilvl = 10
#var dropped_items = []
#var dropped = false
#var inventory_items = []
#var current_body_armor_id
#var current_weapon_id
#var current_gloves_id
#var current_boots_id
#var current_ammo
#var current_ammo_num = 0
#var stats
#var prev_scene
#var GUI = null
#var entities = []
#var enemies
#var enemy_pos
#var enemy_dir
#var enemy_id
#var enemy_num
#var enemy_tracker = null
#var enemy_removed = false
#var enemy_hp
#var enemy_hp_value
#var all_attack = false
#var boss = null
#var shop_spawn_pos
#var shop_spawned = false
#var regex
#var respawn = false
#var pwr_upDB
#var add_stats = false
#var game_started = false
