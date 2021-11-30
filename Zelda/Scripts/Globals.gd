extends Node

var player = null
var current_scene = null
var player_spawn_pos = null
var player_weapon = false
var player_hp = 300
var player_xp = 0
var player_lvl = 0
var player_pwr = 50
var inventory
var inventory_items = []
var prev_scene
var GUI = null
var enemy_pos
var enemy_dir
var enemy_id
var enemy_tracker = null
var enemy_hp
var boss = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func goto_scene(path, spawn):

	call_deferred("_deferred_goto_scene", path, spawn)

func _deferred_goto_scene(path, spawn):
	
	current_scene.free()
	prev_scene = spawn
	
	current_scene = ResourceLoader.load(path).instance()
	get_tree().get_root().add_child(current_scene)
	if path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn":
		player = ResourceLoader.load("res://Scenes/Player.tscn").instance()
		inventory = ResourceLoader.load("res://Scenes/Inventory.tscn").instance()
		GUI = ResourceLoader.load("res://Scenes/GUI.tscn").instance()
		
		current_scene.add_child(player)
		current_scene.add_child(GUI)
		player.add_child(inventory)
		
		inventory.rect_position = player.position
		
		if prev_scene != "start_screen" and prev_scene != "game_over_screen" and prev_scene != "game_won_screen" and path != "res://Scenes/game_over_screen.tscn" and path != "res://Scenes/game_won_screen.tscn":
#			wtf is dis
			player_spawn_pos = current_scene.get_node("PlayerSpawn").position
			GUI.get_node("hp_num").text = str(player_hp)
			GUI.get_node("lvl_progress").value = player_xp
			GUI.get_node("lvl").text = str(player_lvl)
		else:
			player_spawn_pos = Vector2(512, 300)
		
		player.position = player_spawn_pos
		
		for i in enemy_pos.size():
			spawn_enemies(i)
			i += 1
			
		enemy_tracker = enemy_pos.size()
		GUI.get_node("number").text = str(enemy_tracker)
	
	if player_weapon and current_scene.name == "Shop":
#		current_scene.get_node("Weapons_TileMap").tile_set.remove_tile(current_scene.get_node("Weapons_TileMap").tile_set.find_tile_by_name(player_weapon))
		current_scene.get_node("Weapons_TileMap").queue_free()
#		Weapons in inventory are still shown in Shop bc only player wep is removed when entering the shop
	
	print_stray_nodes()

func num_of_enemies(n):
	enemy_pos = range(0, n)
	enemy_dir = range(0, n)
	enemy_id = range(0, n)
	enemy_hp = range(0, n)
	
func spawn_enemies(pos):
	var rand = RandomNumberGenerator.new()
	var tilemap = current_scene.get_node("Level_TileMap")

	if current_scene.name == "Starting_World" and prev_scene == "start_screen" or prev_scene == "game_over_screen" or prev_scene == "game_won_screen":
		var spawn_area = current_scene.get_node("spawn_area").rect_size
		var enemy = ResourceLoader.load("res://Scenes/Enemy_goober.tscn").instance() 
		current_scene.add_child(enemy)

		rand.randomize()
		enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
#	
		var dir = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
		enemy.move_vec = dir[rand.randi() % dir.size()]
		
		var distance_to_player = enemy.get_global_position().distance_to(player.get_global_position())

		if distance_to_player < 150:
			enemy.position = Vector2(rand.randf_range(0, spawn_area.x), rand.randf_range(0, spawn_area.y))
		
		spawn_correction(tilemap, enemy)
		
		enemy_pos.remove(pos)
		enemy_dir.remove(pos)
		enemy_id.remove(pos)
		enemy_hp.remove(pos)
		enemy_pos.push_front(Vector2(enemy.position.x, enemy.position.y))
		enemy_dir.push_front(enemy.move_vec)
		enemy_id.push_front(str(enemy))
		enemy_hp.push_front(150)

	elif current_scene.name == "Starting_World":
		var enemy = ResourceLoader.load("res://Scenes/Enemy_goober.tscn").instance() 
		current_scene.add_child(enemy)
		enemy.position = enemy_pos[pos]
		enemy.move_vec = enemy_dir[pos]
		enemy_id[pos] = (str(enemy))
		
		spawn_correction(tilemap, enemy)
			
func spawn_correction(tilemap, i):
	if !tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(i.position))).begins_with("floor_tiles"):
			i.queue_free()

