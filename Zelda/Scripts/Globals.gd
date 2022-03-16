extends Node

var player = null
var current_scene = null
var next_scene
var player_spawn_pos = null
var player_weapon = false
var starter_weapon = true
var player_hp = 300
var player_xp = 0
var player_lvl = 0
var player_pwr
var player_resistance = {"fire": 10, "cold": 10, "lightning": 10, "physical": 10, "poison": 10}
var enemy_resistance
var damage_type
var max_mana = 100
var poison_stacks = 0
var current_mana
var dex = 0
var intel = 0
var stren = 0
var player_attack = false
var inventory
var Items
var item
var item_id = 0
var ilvl = 10
var dropped_items = []
var dropped = false
var inventory_items = []
var current_armor_id
var current_weapon_id
var current_ammo = "standard"
var current_ammo_num = 0
var stats
var prev_scene
var GUI = null
var enemies
var enemy_pos
var enemy_dir
var enemy_id
var enemy_num = 5
var enemy_tracker = null
var enemy_removed = false
var enemy_hp
var all_attack = false
var boss = null
var shop_spawn_pos
var shop_spawned = false
var regex

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func goto_scene(path, spawn):	
	
	call_deferred("_deferred_goto_scene", path, spawn)

func _deferred_goto_scene(path, spawn):
	
	prev_scene = spawn
	current_scene.free()
	
	next_scene = random_scene()
	
	current_scene = ResourceLoader.load(path).instance()
	get_tree().get_root().add_child(current_scene)
	if path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn":
		player = ResourceLoader.load("res://Scenes/Player.tscn").instance()
		inventory = ResourceLoader.load("res://Scenes/Inventory.tscn").instance()
		GUI = ResourceLoader.load("res://Scenes/GUI.tscn").instance()
		GUI.get_node("mana_progress").max_value = max_mana
		Items = ResourceLoader.load("res://Scenes/Items.tscn").instance()
		
		current_scene.add_child(player)
		current_scene.add_child(GUI)
		current_scene.add_child(Items)
		player.add_child(inventory)
		
		GUI.get_node("res").get_node("fire").get_node("fire").text = str(player_resistance["fire"])
		GUI.get_node("res").get_node("cold").get_node("cold").text = str(player_resistance["cold"])
		GUI.get_node("res").get_node("lightning").get_node("lightning").text = str(player_resistance["lightning"])
		GUI.get_node("res").get_node("physical").get_node("physical").text = str(player_resistance["physical"])
		GUI.get_node("res").get_node("poison").get_node("poison").text = str(player_resistance["poison"])
		
		inventory.get_child(0).rect_position = player.position
		
		if prev_scene != "start_screen" and prev_scene != "game_over_screen" and prev_scene != "game_won_screen" and path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn":
#		if prev_scene == "shop":
#		wtf is dis
			if current_scene.name == "Starting_World":
				current_scene.get_node("Player_Spawn").position = shop_spawn_pos
				
			player_spawn_pos = current_scene.get_node("Player_Spawn").position
			GUI.get_node("hp_num").text = str(player_hp)
			GUI.get_node("hp_visual").value = player_hp
			GUI.get_node("lvl_progress").value = player_xp
			GUI.get_node("lvl").text = str(player_lvl)
			GUI.get_node("mana_progress").max_value = max_mana
			GUI.get_node("mana_progress").value = int(current_mana)
			GUI.get_node("mana_progress").get_node("mana_value").text = current_mana
			GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"), current_armor_id)
			GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("intel"), current_armor_id)
			GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("stren"), current_armor_id)
			GUI.get_node("stat_screen").get_node("dex").get_node("dex").text = str(dex)
			GUI.get_node("stat_screen").get_node("int").get_node("intel").text = str(intel)
			GUI.get_node("stat_screen").get_node("str").get_node("stren").text = str(stren)
			GUI.remove_points(Globals.GUI.get_node("res").get_node("fire").get_node("fire"), current_armor_id)
			GUI.remove_points(Globals.GUI.get_node("res").get_node("cold").get_node("cold"), current_armor_id)
			GUI.remove_points(Globals.GUI.get_node("res").get_node("lightning").get_node("lightning"), current_armor_id)
			GUI.remove_points(Globals.GUI.get_node("res").get_node("physical").get_node("physical"), current_armor_id)
			GUI.remove_points(Globals.GUI.get_node("res").get_node("poison").get_node("poison"), current_armor_id)
			GUI.get_node("res").get_node("fire").get_node("fire").text = str(player_resistance["fire"])
			GUI.get_node("res").get_node("cold").get_node("cold").text = str(player_resistance["cold"])
			GUI.get_node("res").get_node("lightning").get_node("lightning").text = str(player_resistance["lightning"])
			GUI.get_node("res").get_node("physical").get_node("physical").text = str(player_resistance["physical"])
			GUI.get_node("res").get_node("poison").get_node("poison").text = str(player_resistance["poison"])
			GUI.get_node("ammo").text = current_ammo
			GUI.get_node("ammo_num").text = str(current_ammo_num)
			
#			player_pwr += stren
			player.move_speed += (0.1*dex)
			GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("power").get_node("power"), current_weapon_id)
			GUI.get_node("stat_screen").get_node("power").get_node("power").text = str(player_pwr)
			
#			ilvl += 10
		else:
			player_spawn_pos = Vector2(512, 300)
			player_lvl = 0
			player_pwr = 50
			GUI.get_node("mana_progress").get_node("mana_value").text = str(max_mana)
			current_mana = max_mana
			player_weapon = "1"
			var weapon = ItemDB.WEAPON[player_weapon]
			weapon["id"] = Globals.item_id
			weapon["power"] = 5
			Globals.item_id += 1
			inventory_items.push_front(weapon)
			inventory.get_child(0).pickup_item(inventory_items[0])
			GUI.get_node("stat_screen").get_node("power").get_node("power").text = str(player_pwr)
			GUI.get_node("ammo").text = current_ammo
			GUI.get_node("ammo_num").text = str(current_ammo_num)

		player.position = player_spawn_pos

		spawn_enemy_type()
		
		GUI.get_node("lvl_preview").get_node("Next Level").get_node("lvl_name").text = regex.search(next_scene).get_string()
			
		enemy_tracker = enemy_pos.size()
		GUI.get_node("number").text = str(enemy_tracker)
	
#	if current_scene.name == "Shop" and player_weapon and !starter_weapon:
#		current_scene.get_node("Weapons_TileMap").tile_set.remove_tile(current_scene.get_node("Weapons_TileMap").tile_set.find_tile_by_name(player_weapon))
#		current_scene.get_node("Weapons_TileMap").queue_free()
	if current_scene.name == "Shop" and player_weapon and starter_weapon:
		starter_weapon = false
		var rand = RandomNumberGenerator.new()
		var ammo = current_scene.get_node("Ammo_TileMap").get_tileset().get_tiles_ids()
		rand.randomize()
		current_scene.get_node("Ammo_TileMap").set_cell(14,8,rand.randi_range(0, ammo.size()-1))
		current_scene.get_node("Ammo_TileMap").set_cell(15,8,rand.randi_range(0, ammo.size()-1))
		while current_scene.get_node("Ammo_TileMap").get_cell(14,8) == current_scene.get_node("Ammo_TileMap").get_cell(15,8):
			current_scene.get_node("Ammo_TileMap").set_cell(15,8,rand.randi_range(1, ammo.size()-1))
		current_scene.get_node("ammo_capacity").text = str(ilvl*2)
		current_scene.get_node("ammo_capacity_two").text = str(ilvl*2)

#		Weapons in inventory are still shown in Shop bc only player wep is removed when entering the shop	
	print_stray_nodes()

func random_scene():
	var scenes = ["Snow_World", "Desert_World", "Jungle_World", "Fire_World", "lightning_World"]
#	var scenes = ["lightning_World"]
	var rand = RandomNumberGenerator.new()
	
	rand.randomize()
	
	return scenes[rand.randf_range(0, scenes.size())]
	
func spawn_enemy_type():
	regex = RegEx.new()
	regex.compile("^[^_]+")
	var scene = current_scene.name
	var type = regex.search(scene).get_string()
	var enemy_type = "Enemy_" + type
	
	for i in enemy_pos.size():
		spawn_enemies(i, enemy_type)

func num_of_enemies(n):
	enemy_pos = range(0, n)
	enemy_dir = range(0, n)
	enemy_id = range(0, n)
	enemy_hp = range(0, n)
	enemies = range(0, n)
	
func spawn_enemies(pos, type):
	var rand = RandomNumberGenerator.new()
	var tilemap = current_scene.get_node("Level_TileMap")

	if "World" in current_scene.name and prev_scene == "start_screen" or prev_scene == "game_over_screen" or prev_scene == "game_won_screen" or "World" in prev_scene:
		var spawn_area = current_scene.get_node("spawn_area").rect_size
		var enemy = ResourceLoader.load("res://Scenes/" + type + ".tscn").instance()

		current_scene.add_child(enemy) 

		rand.randomize()
		enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
#	
		var dir = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
		enemy.move_vec = dir[rand.randi() % dir.size()]
		
		var distance_to_player = enemy.get_global_position().distance_to(player.get_global_position())

		if distance_to_player < 150:
			enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
			
		if "Fire" in current_scene.name:
			enemy_resistance = {"fire": 70, "cold": 10, "lightning": 10, "physical": 10, "poison": 5}
		if "Starting" in current_scene.name:
			enemy_resistance = {"fire": 10, "cold": 10, "lightning": 10, "physical": 70, "poison": 5}
		if "lightning" in current_scene.name:
			enemy_resistance = {"fire": 10, "cold": 10, "lightning": 70, "physical": 10, "poison": 5}
		if "Snow" in current_scene.name:
			enemy_resistance = {"fire": 10, "cold": 70, "lightning": 10, "physical": 10, "poison": 5}
		if "Desert" in current_scene.name:
			enemy_resistance = {"fire": 10, "cold": 10, "lightning": 10, "physical": 10, "poison": 70}
		if "Jungle" in current_scene.name:
			enemy_resistance = {"fire": 10, "cold": 10, "lightning": 70, "physical": 10, "poison": 5}
		
#		if !tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(enemy.position))).begins_with("floor_tiles"):
#			print(tilemap.get_cellv(tilemap.world_to_map(enemy.position)))
#			enemy.queue_free()
#			spawn_enemies(pos)
#			return
		
		enemy_pos.remove(pos)
		enemy_dir.remove(pos)
		enemy_id.remove(pos)
		enemy_hp.remove(pos)
		enemies.remove(pos)
		enemy_pos.push_front(Vector2(enemy.position.x, enemy.position.y))
		enemy_dir.push_front(enemy.move_vec)
		enemy_id.push_front(str(enemy))
		enemy_hp.push_front(150)
		enemies.push_front(enemy)

# coming back from shop
	elif current_scene.name == "Starting_World":
		var enemy = ResourceLoader.load("res://Scenes/" + type + ".tscn").instance() 
		current_scene.add_child(enemy)
		enemy.position = enemy_pos[pos]
		enemy.move_vec = enemy_dir[pos]
		enemy_id[pos] = (str(enemy))
		enemies[pos] = enemy
	
func spawn_weapon_shop():
	var rand = RandomNumberGenerator.new()
	var shop_entrance = ResourceLoader.load("res://Scenes/Weapon_Shop_Entrance.tscn").instance()
	var wep_spawn_area = current_scene.get_node("weaponshop_spawn_area").rect_size
	current_scene.get_node("weaponshop_spawn_area").call_deferred("add_child", shop_entrance)
	
	rand.randomize()
	shop_entrance.position = Vector2(rand.randf_range(0, wep_spawn_area.x), rand.randf_range(0, wep_spawn_area.y))
	shop_spawn_pos = shop_entrance.position
	
	print("shop spawned")
	
func drop_weighting(num):
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var sum = 0
	var n = rand.randf()
	
	for i in num:
		sum += num[i]
		if n <= sum: 
			return i
			
func drop(pos):
	var rand = RandomNumberGenerator.new()
	rand.randomize()
#	var weighting = drop_weighting({0:0.75, 1:0.15, 2:0.10})
	var weighting = drop_weighting({0:0.10, 1:0.45, 2:0.45})
	var freq = rand.randi_range(0,2)
	
#	if freq == 1:	
	if weighting == 0:
		drop_pwrup(pos)
	elif weighting == 1:
		drop_body_armour(pos, ilvl)
	elif weighting == 2:
		drop_weapon(pos, ilvl)
	
func drop_pwrup(pos):
	var drop_id = drop_weighting({0:0.05, 1:0.15, 2:0.15, 3:0.15, 4:0.35, 5:0.15})
	var drop_texture = Items.get_tileset().tile_get_texture(drop_id)
	var drop_name = Items.get_tileset().tile_get_name(drop_id)
	var drop = ResourceLoader.load("res://Scenes/body_armour_drop.tscn").instance()

	current_scene.call_deferred("add_child", drop)
	drop.get_node("drop_sprite").set_texture(drop_texture)
	drop.name = drop_name

	drop.position = pos

func drop_body_armour(pos, ilvl):
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	item = ItemDB.ARMOR[str(rand.randi_range(1, ItemDB.ARMOR.size()))]

	var stats = [(item["int"] + rand.randi_range(0, ilvl)), (item["str"] + rand.randi_range(0, ilvl)), (item["dex"] + rand.randi_range(0, ilvl))]
	rand.randomize()
	
	var res = [(item["fire"] + rand.randi_range(0, ilvl)), (item["cold"] + rand.randi_range(0, ilvl)), (item["lightning"] + rand.randi_range(0, ilvl)),
	(item["physical"]+rand.randi_range(0, ilvl)), (item["poison"]+rand.randi_range(0, ilvl))]

	var drop = ResourceLoader.load("res://Scenes/body_armour_drop.tscn").instance()
	current_scene.call_deferred("add_child", drop)
	
	drop.get_node("drop_sprite").set_texture(ResourceLoader.load(item["icon"]))
	
	drop.position = pos
	drop.name = "item"
	
	drop.get_node("id").text = str(item_id)	
		
	drop.get_node("stats_tt").get_node("stats").get_node("item_name").text = item["name"]
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("dex").get_node("value").text = str(stats[2])
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("str").get_node("value").text = str(stats[1])
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("int").get_node("value").text = str(stats[0])
	
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("res").get_node("fire").get_node("value").text = str(res[0])
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("res").get_node("cold").get_node("value").text = str(res[1])
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("res").get_node("lightning").get_node("value").text = str(res[2])
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("res").get_node("physical").get_node("value").text = str(res[3])
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("res").get_node("poison").get_node("value").text = str(res[4])
	
	var icon = item.icon
	
	item = {
		"id": item_id,
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
	}
	
	dropped_items.push_front(item)
	item_id += 1

func drop_weapon(pos, ilvl):
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	item = ItemDB.WEAPON[str(rand.randi_range(1, ItemDB.WEAPON.size()))]
	
	var potency = (item["power"] + rand.randi_range(0, ilvl))
	var drop = ResourceLoader.load("res://Scenes/weapon_drop.tscn").instance()	
	current_scene.call_deferred("add_child", drop)	
	drop.get_node("drop_sprite").set_texture(ResourceLoader.load(item["icon"]))	
	drop.position = pos
	drop.name = "item"	
	drop.get_node("id").text = str(item_id)
	drop.get_node("stats_tt").get_node("stats").get_node("item_name").text = item["name"]
	drop.get_node("stats_tt").get_node("stats").get_node("stats_container").get_node("power").get_node("value").text = str(potency)
	
	var item_name = item.name
	var icon = item.icon
	
	item = {
		"id": item_id,
		"icon": icon,
		"name": item_name,
		"slot": item.slot,
		"power": potency
	}
	
	dropped_items.push_front(item)
	item_id += 1
	

	


