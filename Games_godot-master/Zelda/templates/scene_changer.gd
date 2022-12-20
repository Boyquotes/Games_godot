extends Node

var player
var player_pwr
var player_hp
var GV.Player["player_xp"]
var intel
var stren
var dex
var GV.Player["player_resistance"] = {}
var quantity
var quality
var current_ammo_num
var current_weapon_id
var coins
var GUI
var inventory
var items
var player_spawn_pos
var player_lvl
var enemy_hp_value
var max_mana
var current_mana
var player_weapon
var item_id
var inventory_items = []

func _ready():
	pass

func goto_scene(path, spawn, prev_scene):
	
	call_deferred("_deferred_goto_scene", path, spawn, prev_scene)

func _deferred_goto_scene(path, spawn, prev_scene):
	var root = get_tree().get_root()
	GV.Scenes["current_scene"] = root.get_child(root.get_child_count() - 1)
	
#	|| freeing previous scene ||
	prev_scene = spawn
	GV.Scenes["current_scene"].free()
	
#	|| loading new scene and adding it to the tree ||
	GV.Scenes["current_scene"] = ResourceLoader.load(path).instance()
	get_tree().get_root().add_child(GV.Scenes["current_scene"])

#	|| check if scene is a level screen -> ||
	if path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn" and path != "res://Scenes/pwr_up_screen.tscn":
		
#	|| load game entites ||
		player = ResourceLoader.load("res://Scenes/Player.tscn").instance()
		GUI = ResourceLoader.load("res://Scenes/GUI.tscn").instance()
		inventory = GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("Inventory")
		var GUI_stats = GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
		items = ResourceLoader.load("res://Scenes/Items.tscn").instance()
		
#	|| add game entities to current scene ||
		GV.Scenes["current_scene"].add_child(player)
		GV.Scenes["current_scene"].add_child(GUI)
		GV.Scenes["current_scene"].add_child(items)

#	|| initiate start values if first level loads -> this only loads once at startup of first level scene ||
		if path == "res://Scenes/Levels/Starting_World.tscn":
			player_spawn_pos = Vector2(512, 300)
			player.position = player_spawn_pos
			GV.Player["player_lvl"] = 0
			enemy_hp_value = 150
			GUI.get_node("mana_progress").get_node("mana_value").text = str(max_mana)
			current_mana = max_mana
			GV.Player["player_weapon"] = "3"
			var weapon = ItemDB.WEAPON[GV.Player["player_weapon"]]
			weapon["id"] = Globals.item_id
			weapon["power"] = 900
			weapon["dmg_type"] = "physical"
			weapon["special"] = ""
			item_id += 1
			inventory_items.push_front(weapon)
			inventory.pickup_item(inventory_items[0])
			var body_armor = ItemDB.STARTER_ITEMS["1"]
			body_armor["id"] = Globals.item_id
			item_id += 1
			inventory_items.push_front(body_armor)
			inventory.pickup_item(inventory_items[0])
			GUI_stats.get_node("stat_screen").get_node("power").get_node("power").text = str(player_pwr)
			
#	|| load global (changed) values from GUI if regular level load ||
		else:
			player_spawn_pos = GV.Scenes["current_scene"].get_node("Player_Spawn").position
			player.position = player_spawn_pos
			GUI.get_node("hp_num").text = str(player_hp)
			GUI.get_node("hp_visual").value = player_hp
			GUI.get_node("lvl_progress").value = GV.Player["player_xp"]
			GUI.get_node("lvl").text = str(GV.Player["player_lvl"])
			GUI.get_node("mana_progress").max_value = max_mana
			GUI.get_node("mana_progress").value = int(current_mana)
			GUI.get_node("mana_progress").get_node("mana_value").text = current_mana
			GUI_stats.get_node("stat_screen").get_node("dex").get_node("dex").text = str(dex)
			GUI_stats.get_node("stat_screen").get_node("int").get_node("intel").text = str(intel)
			GUI_stats.get_node("stat_screen").get_node("str").get_node("stren").text = str(stren)
			GUI_stats.get_node("item_stats").get_node("res").get_node("fire").get_node("fire").text = str(GV.Player["player_resistance"]["fire"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("cold").get_node("cold").text = str(GV.Player["player_resistance"]["cold"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("lightning").get_node("lightning").text = str(GV.Player["player_resistance"]["lightning"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("physical").get_node("physical").text = str(GV.Player["player_resistance"]["physical"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("poison").get_node("poison").text = str(GV.Player["player_resistance"]["poison"])
			GUI_stats.get_node("loot_modifiers").get_node("quant_num").text = str(quantity)
			GUI_stats.get_node("loot_modifiers").get_node("qual_num").text = str(quality)
			GUI.get_node("ammo_num").text = str(current_ammo_num)
			GUI.remove_points(GUI_stats.get_node("stat_screen").get_node("power").get_node("power"), current_weapon_id)
			GUI_stats.get_node("stat_screen").get_node("power").get_node("power").text = str(player_pwr)
			GUI.get_node("coins").get_node("coins_num").text = str(coins)
			
#	|| set player position depending on a node in tree of current scene ||
		player.position = GV.Scenes["current_scene"].get_node("player_spawn_pos")

#	|| spawn enemy entities ||
#		spawn_enemy_type()

#	|| print nodes that are not getting freed when scene changes ||
	print_stray_nodes()
	
	
#	regarding global variables: making a dict that holds the global values which then can be modified by all functions of the application may "solve" the global var issue
