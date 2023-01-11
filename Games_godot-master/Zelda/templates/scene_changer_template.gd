extends Node

var player_spawn_pos

func _ready():
	pass

func goto_scene(path, spawn, prev_scene):
	
	call_deferred("_deferred_goto_scene", path, spawn, prev_scene)

func _deferred_goto_scene(path, spawn, prev_scene):
	var root = get_tree().get_root()
	GV.Scene["current_scene"] = root.get_child(root.get_child_count() - 1)
	
#	|| freeing previous scene ||
	prev_scene = spawn
	GV.Scene["current_scene"].free()
	
#	|| loading new scene and adding it to the tree ||
	GV.Scene["current_scene"] = ResourceLoader.load(path).instance()
	get_tree().get_root().add_child(GV.Scene["current_scene"])

#	|| check if scene is a level screen -> ||
	if path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn" and path != "res://Scenes/pwr_up_screen.tscn":
		
#	|| load game entites ||
		GV.Player["player"] = ResourceLoader.load("res://Scenes/Player.tscn").instance()
		GV.GUI["GUI"] = ResourceLoader.load("res://Scenes/GUI.tscn").instance()
		GV.GUI["inventory"] = GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("Inventory")
		var GUI_stats = GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
		GV.Item["Item"] = ResourceLoader.load("res://Scenes/Items.tscn").instance()
		
#	|| add game entities to current scene ||
		GV.Scene["current_scene"].add_child(GV.Player["player"])
		GV.Scene["current_scene"].add_child(GV.GUI["GUI"])
		GV.Scene["current_scene"].add_child(GV.Item["Item"])

#	|| initiate start values if first level loads -> this only loads once at startup of first level scene ||
		if path == "res://Scenes/Levels/Starting_World.tscn":
			player_spawn_pos = Vector2(512, 300)
			GV.Player["player"].position = player_spawn_pos
			GV.Player["player_lvl"] = 0
			GV.Enemy["enemy_hp_value"] = 150
			GV.GUI["GUI"].get_node("mana_progress").get_node("mana_value").text = str(GV.GUI["max_mana"])
			GV.GUI["current_mana"] = GV.GUI["max_mana"]
			GV.Player["player_weapon"] = "3"
			var weapon = ItemDB.WEAPON[GV.Player["player_weapon"]]
			weapon["id"] = GV.Item["item_id"]
			weapon["power"] = 900
			weapon["dmg_type"] = "physical"
			weapon["special"] = ""
			GV.Item["item_id"] += 1
			GV.Item["inventory_items"].push_front(weapon)
			GV.GUI["inventory"].pickup_item(GV.Item["inventory_items"][0])
			var body_armor = ItemDB.STARTER_ITEMS["1"]
			body_armor["id"] = GV.Item["item_id"]
			GV.Item["item_id"] += 1
			GV.Item["inventory_items"].push_front(body_armor)
			GV.GUI["inventory"].pickup_item(GV.Item["inventory_items"][0])
			GUI_stats.get_node("stat_screen").get_node("power").get_node("power").text = GV.Player["player_pwr"]
			
#	|| load (changed) global values from GUI if regular level load ||
		else:
			GV.Player["player"].position = GV.Scene["current_scene"].get_node("Player_Spawn").position
			GV.GUI["GUI"].get_node("hp_num").text = str(GV.Player["player_hp"])
			GV.GUI["GUI"].get_node("hp_visual").value = GV.Player["player_hp"]
			GV.GUI["GUI"].get_node("lvl_progress").value = GV.Player["player_xp"]
			GV.GUI["GUI"].get_node("lvl").text = str(GV.Player["player_lvl"])
			GV.GUI["GUI"].get_node("mana_progress").max_value = GV.GUI["max_mana"]
			GV.GUI["GUI"].get_node("mana_progress").value = int(GV.GUI["current_mana"])
			GV.GUI["GUI"].get_node("mana_progress").get_node("mana_value").text = GV.GUI["current_mana"]
			GUI_stats.get_node("stat_screen").get_node("dex").get_node("dex").text = str(GV.GUI["dex"])
			GUI_stats.get_node("stat_screen").get_node("int").get_node("intel").text = str(GV.GUI["intel"])
			GUI_stats.get_node("stat_screen").get_node("str").get_node("stren").text = str(GV.GUI["stren"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("fire").get_node("fire").text = str(GV.Player["player_resistance"]["fire"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("cold").get_node("cold").text = str(GV.Player["player_resistance"]["cold"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("lightning").get_node("lightning").text = str(GV.Player["player_resistance"]["lightning"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("physical").get_node("physical").text = str(GV.Player["player_resistance"]["physical"])
			GUI_stats.get_node("item_stats").get_node("res").get_node("poison").get_node("poison").text = str(GV.Player["player_resistance"]["poison"])
			GUI_stats.get_node("loot_modifiers").get_node("quant_num").text = str(GV.Item["quantity"])
			GUI_stats.get_node("loot_modifiers").get_node("qual_num").text = str(GV.Item["quality"])
			GV.GUI["GUI"].get_node("ammo_num").text = str(GV.Item["current_ammo_num"])
			GV.GUI["GUI"].remove_points(GUI_stats.get_node("stat_screen").get_node("power").get_node("power"), GV.Item["current_weapon_id"])
			GUI_stats.get_node("stat_screen").get_node("power").get_node("power").text = str(GV.Player["player_pwr"])
			GV.GUI["GUI"].get_node("coins").get_node("coins_num").text = str(GV.GUI["coins"])
			
#	|| set player position depending on a node in tree of current scene ||
		GV.Player["player"].position = GV.Scene["current_scene"].get_node("player_spawn_pos")

#	|| spawn enemy entities ||
		GF.spawn_enemy_type()

#	|| print nodes that are not getting freed when scene changes ||
	print_stray_nodes()
