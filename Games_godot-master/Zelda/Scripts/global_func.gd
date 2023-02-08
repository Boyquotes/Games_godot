extends Node

var item #only in GF
var stats #only in GF
var shop_spawn_pos #only in GF
var regex #only in GF
var game_started = false #only in GF

func _ready():
	var root = get_tree().get_root()
	GV.Scene["current_scene"] = root.get_child(root.get_child_count() - 1)
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func goto_scene(path, spawn):
	
	call_deferred("_deferred_goto_scene", path, spawn)

func _deferred_goto_scene(path, spawn):
	
	GV.Scene["prev_scene"] = spawn
	GV.Scene["current_scene"].free()
	
	GV.Scene["current_scene"] = ResourceLoader.load(path).instance()
	get_tree().get_root().add_child(GV.Scene["current_scene"])

	if GV.Scene["current_scene"].name != "Boss_Room" and GV.Scene["current_scene"].name != "pwr_up_screen":
		GV.Scene["next_scene"] = random_scene()
	
	if path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn" and path != "res://Scenes/pwr_up_screen.tscn":
#		GV.GUI["inventory"] = ResourceLoader.load("res://Scenes/GV.GUI["GUI"].tscn").instance().get_node("stat_container").get_node("Inventory")
		GV.Player["player"] = ResourceLoader.load("res://Scenes/Player.tscn").instance()
		GV.GUI["GUI"] = ResourceLoader.load("res://Scenes/GUI.tscn").instance()
		GV.GUI["inventory"] = GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("Inventory")
		var GUI_stats = GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
		GV.GUI["GUI"].get_node("mana_progress").max_value = GV.GUI["max_mana"]
		GV.Item["Item"] = ResourceLoader.load("res://Scenes/Items.tscn").instance()
		
		GV.Scene["current_scene"].add_child(GV.Player["player"])
		GV.Scene["current_scene"].add_child(GV.GUI["GUI"])
		GV.Scene["current_scene"].add_child(GV.Item["Item"])
#		player.add_child(GV.GUI["inventory"])
		
#		GV.GUI["inventory"].get_child(0).rect_position = player.position

#		load start scene
		if path == "res://Scenes/Levels/Starting_World.tscn" and game_started == false:
			GV.GUI["add_stats"] = true
#			player_spawn_pos = Vector2(512, 300)
			GV.Player["player"].position = Vector2(512, 300)
			GV.Player["player_lvl"] = 0
			GV.Enemy["enemy_hp_value"] = 50
			GV.GUI["GUI"].get_node("mana_progress").get_node("mana_value").text = str(GV.GUI["max_mana"])
			GV.GUI["current_mana"] = GV.GUI["max_mana"]
			GV.Player["player_weapon"] = "1"
			var weapon = ItemDB.WEAPON[GV.Player["player_weapon"]]
			weapon["id"] = GV.Item["item_id"]
			weapon["power"] = 300
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
			GUI_stats.get_node("stat_screen").get_node("power").get_node("power").text = str(GV.Player["player_pwr"])
			spawn_enemy_type()
			game_started = true
		else:
#			if GV.Scene["current_scene"].name == "Starting_World":
#				GV.Scene["current_scene"].get_node("Player_Spawn").position = shop_spawn_pos
#			if GV.Scene["portal_spawned"]:
#				spawn_boss_portal()
#			load change scene
#			player_spawn_pos = GV.Scene["current_scene"].get_node("Player_Spawn").position
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
			
			if GV.Player["player_weapon"] == "bow":
				GV.GUI["GUI"].get_node("ammo").text = GV.Item["current_ammo"]
			GV.GUI["GUI"].get_node("ammo_num").text = str(GV.Item["current_ammo_num"])
#			GV.Player["player"].move_speed += (0.1*dex)
			GV.GUI["GUI"].remove_points(GUI_stats.get_node("stat_screen").get_node("power").get_node("power"), GV.Item["current_weapon_id"])
			GUI_stats.get_node("stat_screen").get_node("power").get_node("power").text = str(GV.Player["player_pwr"])
			GV.GUI["GUI"].get_node("coins").get_node("coins_num").text = str(GV.GUI["coins"])
			spawn_enemy_type()
		
#		GV.Player["player"].position = player_spawn_pos

		
#		if GV.Scene["current_scene"].name == "Boss_World":
#			GV.GUI["GUI"].get_node("lvl_preview").get_node("Next Level").get_node("lvl_name").text = regex.search(next_scene).get_string()
#		else:
		GV.GUI["GUI"].get_node("lvl_preview").get_node("Next Level").get_node("lvl_name").text = regex.search(GV.Scene["next_scene"]).get_string()
			
#		GV.Enemy["enemy_tracker"] = enemy_pos.size()
		GV.GUI["GUI"].get_node("number").text = str(GV.Enemy["enemy_tracker"])
	
#	if GV.Scene["current_scene"].name == "Shop" and player_weapon and !starter_weapon:
#		GV.Scene["current_scene"].get_node("Weapons_TileMap").tile_set.remove_tile(GV.Scene["current_scene"].get_node("Weapons_TileMap").tile_set.find_tile_by_name(player_weapon))
#		GV.Scene["current_scene"].get_node("Weapons_TileMap").queue_free()
#	if GV.Scene["current_scene"].name == "Shop" and GV.Player["player_weapon"]: #and starter_weapon:
##		starter_weapon = false
#		var rand = RandomNumberGenerator.new()
#		var ammo = GV.Scene["current_scene"].get_node("Ammo_TileMap").get_tileset().get_tiles_ids()
#		rand.randomize()
#		GV.Scene["current_scene"].get_node("Ammo_TileMap").set_cell(14,8,rand.randi_range(0, ammo.size()-1))
##		GV.Scene["current_scene"].get_node("Ammo_TileMap").set_cell(14,8,5)
#		GV.Scene["current_scene"].get_node("Ammo_TileMap").set_cell(15,8,rand.randi_range(0, ammo.size()-1))
#		GV.Scene["current_scene"].get_node("ammo_price").text = str(50)
#		GV.Scene["current_scene"].get_node("ammo_price_two").text = str(50)
#		while GV.Scene["current_scene"].get_node("Ammo_TileMap").get_cell(14,8) == GV.Scene["current_scene"].get_node("Ammo_TileMap").get_cell(15,8):
#			GV.Scene["current_scene"].get_node("Ammo_TileMap").set_cell(15,8,rand.randi_range(1, ammo.size()-1))
#		GV.Scene["current_scene"].get_node("ammo_capacity").text = str(GV.Item["ilvl"]*2)
#		GV.Scene["current_scene"].get_node("ammo_capacity_two").text = str(GV.Item["ilvl"]*2)
		
#	block_attribute_changes = false

#		Weapons in GV.GUI["inventory"] are still shown in Shop bc only player wep is removed when entering the shop	
	print_stray_nodes()
	
#	pwr_upDB = ResourceLoader.load("res://Scripts/pwr_upDB.gd").instance() 

func random_scene():
	var scenes = ["Snow_World", "Desert_World", "Jungle_World", "Fire_World", "lightning_World"]
#	var scenes = ["Lightning_World"]
	var rand = RandomNumberGenerator.new()
	
	rand.randomize()
	
	return scenes[rand.randf_range(0, scenes.size())]
	
func spawn_enemy_type():
	regex = RegEx.new()
	regex.compile("^[^_]+")
	var scene = GV.Scene["current_scene"].name
	var type = regex.search(scene).get_string()
	var enemy_type = "Enemy_" + type
	
	for i in GV.Enemy["enemy_pos"].size():
#		call_deferred("spawn_enemies", i, enemy_type)
		spawn_enemies(i, enemy_type)
	GV.Enemy["respawn"] = false

func num_of_enemies(n):
	GV.Enemy["enemy_pos"] = range(0, n)
	GV.Enemy["enemy_dir"] = range(0, n)
	GV.Enemy["enemy_id"] = range(0, n)
	GV.Enemy["enemy_hp"] = range(0, n)
	GV.Enemy["enemies"] = range(0, n)
	GV.Enemy["enemy_tracker"] = n
	
func spawn_enemies(pos, type):
	var rand = RandomNumberGenerator.new()
	var tilemap = GV.Scene["current_scene"].get_node("Level_TileMap")

	if "World" in GV.Scene["current_scene"].name: #and prev_scene == "start_screen" or prev_scene == "game_over_screen" or prev_scene == "game_won_screen" or prev_scene == "pwr_up_screen" or "World" in prev_scene or GV.Enemy["respawn"]:
		var spawn_area = GV.Scene["current_scene"].get_node("spawn_area").rect_size
		var enemy = ResourceLoader.load("res://Scenes/" + type + ".tscn").instance()

#		GV.Scene["current_scene"].call_deferred("add_child", enemy)
		if GV.Enemy["respawn"] == false:
			GV.Scene["current_scene"].add_child(enemy)
		else:
			GV.Scene["current_scene"].call_deferred("add_child", enemy)
			
		
#		GV.Enemy["respawn"] enemies when coming back from shop
		if GV.Scene["current_scene"].name == "Starting_World" and game_started and GV.Enemy["respawn"] == false:
			enemy.position = GV.Enemy["enemy_pos"][pos]
			enemy.move_vec = GV.Enemy["enemy_dir"][pos]
			GV.Enemy["enemy_id"][pos] = (str(enemy))
			GV.Enemy["enemies"][pos] = enemy
			GV.Enemy["enemy_entites"][pos] = enemy 
#			GV.Enemy["respawn"] = false
#			spawn enemies
		else:
			rand.randomize()
#			enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
			var dir = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
			enemy.move_vec = dir[rand.randi() % dir.size()]
			enemy.get_node("hp_bar").max_value = GV.Enemy["enemy_hp_value"]
			enemy.get_node("hp_bar").value = GV.Enemy["enemy_hp_value"]
			
			enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
			var distance_to_player = enemy.get_global_position().distance_to(GV.Player["player"].get_global_position())
			while distance_to_player < 200:
				enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
				distance_to_player = enemy.get_global_position().distance_to(GV.Player["player"].get_global_position())

			if "Fire" in GV.Scene["current_scene"].name:
				GV.Enemy["enemy_resistance"] = {"fire": 7*GV.Enemy["enemy_res_modifier"], "cold": 2*GV.Enemy["enemy_res_modifier"], "lightning": 5*GV.Enemy["enemy_res_modifier"], "physical": 5*GV.Enemy["enemy_res_modifier"], "poison": 5*GV.Enemy["enemy_res_modifier"]}
			if "Starting" in GV.Scene["current_scene"].name:
				GV.Enemy["enemy_resistance"] = {"fire": 3*GV.Enemy["enemy_res_modifier"], "cold": 3*GV.Enemy["enemy_res_modifier"], "lightning": 3*GV.Enemy["enemy_res_modifier"], "physical": 7*GV.Enemy["enemy_res_modifier"], "poison": 1*GV.Enemy["enemy_res_modifier"]}
			if "lightning" in GV.Scene["current_scene"].name:
				GV.Enemy["enemy_resistance"] = {"fire": 5*GV.Enemy["enemy_res_modifier"], "cold": 5*GV.Enemy["enemy_res_modifier"], "lightning": 7*GV.Enemy["enemy_res_modifier"], "physical": 2*GV.Enemy["enemy_res_modifier"], "poison": 5*GV.Enemy["enemy_res_modifier"]}
			if "Snow" in GV.Scene["current_scene"].name:
				GV.Enemy["enemy_resistance"] = {"fire": 2*GV.Enemy["enemy_res_modifier"], "cold": 7*GV.Enemy["enemy_res_modifier"], "lightning": 5*GV.Enemy["enemy_res_modifier"], "physical": 5*GV.Enemy["enemy_res_modifier"], "poison": 5*GV.Enemy["enemy_res_modifier"]}
			if "Desert" in GV.Scene["current_scene"].name:
				GV.Enemy["enemy_resistance"] = {"fire": 2*GV.Enemy["enemy_res_modifier"], "cold": 5*GV.Enemy["enemy_res_modifier"], "lightning": 5*GV.Enemy["enemy_res_modifier"], "physical": 3*GV.Enemy["enemy_res_modifier"], "poison": 7*GV.Enemy["enemy_res_modifier"]}
			if "Jungle" in GV.Scene["current_scene"].name:
				GV.Enemy["enemy_resistance"] = {"fire": 5*GV.Enemy["enemy_res_modifier"], "cold": 5*GV.Enemy["enemy_res_modifier"], "lightning": 5*GV.Enemy["enemy_res_modifier"], "physical": 5*GV.Enemy["enemy_res_modifier"], "poison": 2*GV.Enemy["enemy_res_modifier"]}
			
	#		if !tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(enemy.position))).begins_with("floor_tiles"):
	#			print(tilemap.get_cellv(tilemap.world_to_map(enemy.position)))
	#			enemy.queue_free()
	#			spawn_enemies(pos)
	#			return		
			GV.Enemy["enemy_pos"].remove(pos)
			GV.Enemy["enemy_dir"].remove(pos)
			GV.Enemy["enemy_id"].remove(pos)
			GV.Enemy["enemy_hp"].remove(pos)
			GV.Enemy["enemies"].remove(pos)
			GV.Enemy["enemy_pos"].push_front(Vector2(enemy.position.x, enemy.position.y))
			GV.Enemy["enemy_dir"].push_front(enemy.move_vec)
			GV.Enemy["enemy_id"].push_front(str(enemy))
			GV.Enemy["enemy_hp"].push_front(GV.Enemy["enemy_hp_value"])
			GV.Enemy["enemies"].push_front(enemy)
			GV.Enemy["enemy_entites"].push_front(enemy)
			

# coming back from shop
#	elif GV.Scene["current_scene"].name == "Starting_World":
#		print("reloadEnemies")
#		var enemy = ResourceLoader.load("res://Scenes/" + type + ".tscn").instance() 
#		GV.Scene["current_scene"].add_child(enemy)
#		enemy.position = GV.Enemy["enemy_pos"][pos]
#		enemy.move_vec = enemy_dir[pos]
#		enemy_id[pos] = (str(enemy))
#		enemies[pos] = enemy
#		entities[pos] = enemy
#
#		GV.Enemy["respawn"] = false
	
func spawn_weapon_shop():
	var rand = RandomNumberGenerator.new()
	var shop_entrance = ResourceLoader.load("res://Scenes/Weapon_Shop_Entrance.tscn").instance()
	var wep_spawn_area = GV.Scene["current_scene"].get_node("weaponshop_spawn_area").rect_size
	GV.Scene["current_scene"].get_node("weaponshop_spawn_area").call_deferred("add_child", shop_entrance)
	
	rand.randomize()
	shop_entrance.position = Vector2(rand.randf_range(0, wep_spawn_area.x), rand.randf_range(0, wep_spawn_area.y))
	shop_spawn_pos = shop_entrance.position
	
	print("shop spawned")
	
func spawn_boss_portal():
	GV.Scene["portal_spawned"] = true
	var Portal = ResourceLoader.load("res://Scenes/Boss_Portal_Entrance.tscn").instance()
	GV.Scene["current_scene"].call_deferred("add_child", Portal)
	GV.Enemy["enemy_entites"].clear()
	GV.Enemy["enemy_entites"].push_front(Portal)
	Portal.get_node("Boss_Portal_Anim").play()
	Portal.position.x = 500
	Portal.position.y = 300
	
func drop_weighting(num):
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var sum = 0
	var n = rand.randf()
	
	for i in num:
		sum += num[i]
		if n <= sum:
			return i

var drop_overlap = false
func drop_spacing(pos, last_pos, rand): 
	drop_overlap = false
	var drop_in_spawn_area = GV.Scene["current_scene"].get_node("spawn_area").rect_size
	rand.randomize()

	for i in last_pos.size():
		var pos_in_bounds = false
		if pos.x in range(18, drop_in_spawn_area.x-18) and pos.y in range(18, drop_in_spawn_area.y-18):
			pos_in_bounds = true
		else:
			pos_in_bounds = false

		if last_pos[i].x in range(pos.x-18,pos.x+18) and last_pos[i].y in range(pos.y-18,pos.y+18):
			drop_overlap = true
			pos = drop_spacing_border_correction(pos, rand)
		if pos_in_bounds == false or pos.x in range(GV.Player["player"].position.x-18, GV.Player["player"].position.x+18) or pos.y in range(GV.Player["player"].position.y-18, GV.Player["player"].position.y+18):
			drop_overlap = true
			pos = drop_spacing_border_correction(pos, rand)
#		if GV.Scene["current_scene"].get_node("Shop_Entrance") != null:
#			if pos.x in range(GV.Scene["current_scene"].get_node("Shop_Entrance").position.x-18, GV.Scene["current_scene"].get_node("Shop_Entrance").position.x+18) or pos.y in range(GV.Scene["current_scene"].get_node("Shop_Entrance").position.x-18, GV.Scene["current_scene"].get_node("Shop_Entrance").position.x+18):
#				print("check_shop_overlap")
#				drop_overlap = true
#				pos = drop_spacing_border_correction(pos, rand)
			
	return pos

func drop_spacing_border_correction(pos, rand):
	rand.randomize()
	if pos.x > 500:
		pos -= Vector2(rand.randi_range(18, 36), rand.randi_range(-36, 36))
	if pos.y > 270:
		pos -= Vector2(rand.randi_range(-36, 36), rand.randi_range(18, 36))
	else:
		pos += Vector2(rand.randi_range(18, 36), rand.randi_range(18, 36))
	return pos

func drop(pos, freq, weighting):
	var rand = RandomNumberGenerator.new()
	rand.randomize()

#	pwrup is 0 armour is 1, weapon is 2
	if weighting == null:
		weighting = drop_weighting({0:0.20, 1:0.20, 2:0.60})

	if weighting == 0:
		drop_pwrup(pos)
	elif weighting == 1:
		var last_pos = []
		var num_items_dropped = 1
		
#		if GV.Scene["current_scene"].name != "Boss_Room":
#			num_items_dropped = rand.randf_range(10, GV.Item["quantity"])/8
#		else:
#			num_items_dropped = 1
		
		print("!! NUMOFITEMS !! ", num_items_dropped)
		
		for i in round(num_items_dropped):
			pos = Vector2(round(pos.x), round(pos.y))
			
			if i >= 1:
				pos = drop_spacing_border_correction(pos, rand)
				pos = drop_spacing(pos, last_pos, rand)
				while drop_overlap == true:
					pos = drop_spacing(pos, last_pos, rand)
					
#			drop_item(pos, GV.Item["ilvl"])
			call_deferred("drop_item", pos, GV.Item["ilvl"])
			last_pos.push_back(pos)
#			print("dropPOS ", pos)
			
	elif weighting == 2:
#		var num_items_dropped = rand.randf_range(10, quantity)/2
#		for i in round(num_items_dropped):
		drop_weapon(pos, GV.Item["ilvl"])
	
func drop_pwrup(pos):
	var drop_id = str(drop_weighting({1:0.13, 2:0.09, 3:0.13, 4:0.13, 5:0.13, 6:0.13, 7:0.13, 8:0.13}))
#	var drop_id = str(drop_weighting({1:0.93, 2:0.01, 3:0.01, 4:0.01, 5:0.01, 6:0.01, 7:0.01, 8:0.01}))
	var drop_texture = ItemDB.PWRUP[drop_id]
	var drop_name = ItemDB.PWRUP[drop_id].name
	var drop = ResourceLoader.load("res://Scenes/body_armour_drop.tscn").instance()
	
	item = ItemDB.PWRUP[drop_id]

	GV.Scene["current_scene"].call_deferred("add_child", drop)
	drop.get_node("drop_sprite").set_texture(ResourceLoader.load(item["icon"]))
	drop.name = drop_name
	drop.position = pos
	drop.get_node("id").text = str(GV.Item["item_id"])
	
	var icon = item.icon
	
	item = {
		"id": GV.Item["item_id"],
		"name": item.name,
		"icon": icon,
		"type": item.type,
		"slot": item.slot
	}
	
	GV.Item["dropped_items"].push_front(item)
	GV.Item["item_id"] += 1

func drop_item(pos, ilvl):
	var rand = RandomNumberGenerator.new()
	var weighting = {}
	var item_types = [ItemDB.ARMOR, ItemDB.GLOVES, ItemDB.BOOTS]
	rand.randomize()
	var item_type = item_types[rand.randi_range(0, item_types.size()-1)]
	
	for i in item_type:
		weighting[i] = item_type[i].weighting
#		num+=1
		
	item = item_type[str(drop_weighting(weighting))]
	
	rand.randomize()
	var stats = [(item["int"] + rand.randi_range(0, ilvl)), (item["str"] + rand.randi_range(0, ilvl)), (item["dex"] + rand.randi_range(0, ilvl))]
	rand.randomize()
	var res = [(item["fire"] + rand.randi_range(0, ilvl)), (item["cold"] + rand.randi_range(0, ilvl)), (item["lightning"] + rand.randi_range(0, ilvl)),
	(item["physical"]+rand.randi_range(0, ilvl)), (item["poison"]+rand.randi_range(0, ilvl))]
	
	var drop = ResourceLoader.load("res://Scenes/body_armour_drop.tscn").instance()
	GV.Scene["current_scene"].call_deferred("add_child", drop)
	
	drop.get_node("drop_sprite").set_texture(ResourceLoader.load(item["icon"]))
#	drop.get_node("drop_sprite").scale.x = 0.5
#	drop.get_node("drop_sprite").scale.y = 0.5
	
	drop.position = pos
	drop.name = "item"
	
	drop.get_node("id").text = str(GV.Item["item_id"])
		
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("item_name").text = item["name"]
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("dex").get_node("value").text = str(stats[2])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("str").get_node("value").text = str(stats[1])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("int").get_node("value").text = str(stats[0])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("res").get_node("fire").get_node("value").text = str(res[0])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("res").get_node("cold").get_node("value").text = str(res[1])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("res").get_node("lightning").get_node("value").text = str(res[2])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("res").get_node("physical").get_node("value").text = str(res[3])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("res").get_node("poison").get_node("value").text = str(res[4])
	
	var icon = item.icon
	
	item = {
		"id": GV.Item["item_id"],
		"name": item.name,
		"icon": icon,
		"type": item.type,
		"slot": item.slot,
		"stren": str(stats[1]),
		"intel": str(stats[0]),
		"dex": str(stats[2]),
		"fire": str(res[0]),
		"cold": str(res[1]),
		"lightning": str(res[2]),
		"physical": str(res[3]),
		"poison": str(res[4]),
		"special": special_mod(rand, drop, ItemDB.ARMOR_SPECIAL, "armor_special"),
#		"special_val": special_mod(rand, drop, ItemDB.ARMOR_SPECIAL, "armor_special")[1],
	}
	
	GV.Item["dropped_items"].push_front(item)
	GV.Item["item_id"] += 1


func drop_weapon(pos, ilvl):
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	item = ItemDB.WEAPON[str(rand.randi_range(1, ItemDB.WEAPON.size()))]
		
	var potency = (rand.randi_range((ilvl*2), (ilvl*3)))*5
	var dmg_types = ["fire", "cold", "lightning", "physical", "poison"]
	var dmg_type = rand.randi_range(0, dmg_types.size()-1)
	var drop = ResourceLoader.load("res://Scenes/weapon_drop.tscn").instance()
	GV.Scene["current_scene"].call_deferred("add_child", drop)
	drop.get_node("drop_sprite").set_texture(ResourceLoader.load(item["icon"]))
	drop.position = pos
	drop.name = "item"
	drop.get_node("id").text = str(GV.Item["item_id"])
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("item_name").text = item["name"]
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("power").get_node("value").text = str(potency)
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node("dmg_type").get_node("value").text = str(dmg_types[dmg_type])
	
	var item_name = item.name
	var icon = item.icon
	
	item = {
		"id": GV.Item["item_id"],
		"icon": icon,
		"name": item_name,
		"type": item.type,
		"slot": item.slot,
		"power": potency,
		"dmg_type": dmg_types[dmg_type],
		"special": special_mod(rand, drop, ItemDB.WEP_SPECIAL, "special_wep")
	}
	
	GV.Item["dropped_items"].push_front(item)
	GV.Item["item_id"] += 1

func special_mod(rand, drop, armor_type, node):
	var special
	var special_val
	rand.randomize()

	var special_chance = rand.randi_range(0, 1)

#	if special_chance == 1:
	var temp_type_arr = []
	for i in armor_type:
		if armor_type[i]["type"] == item["type"]:
			temp_type_arr.push_front(armor_type[i])
	if temp_type_arr.size() == 0:
		temp_type_arr.push_front({"power": "ERROR: no Power available"})

	special = temp_type_arr[rand.randi_range(0, temp_type_arr.size()-1)]
	
	if special["power"] == "quantity" or special["power"] == "quality":
		rand.randomize()
		var n = special_mod_val(rand)
		special["value"] = n
		special_val = n
		special = special["power"] + " " + str(special["value"])
	else:
		special = special["power"]
		
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node(node).visible = true
	drop.get_node("drop_stats_tt").get_node("stats_tt_pop_up").get_node("stats").get_node("stats_container").get_node(node).text = special
#	item["special"] = special

	if special_val != null:
		return [special, special_val]
	else:
		return [special]

func special_mod_val(rand):
	rand.randomize()
	var n = rand.randi_range(GV.Item["ilvl"], GV.Item["ilvl"]+10)
	return n



