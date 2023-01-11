extends KinematicBody2D

var level_tilemap
var objects_tilemap
var weapons_tilemap
var ammo_tilemap
var anim_player
var move_speed
var player_invuln
var axe_pos
var axe_dir
var attacking = false
var weapon_dir
var hp
var mana_progress
var speed_up = false
var dmg_up = false
var is_moving = true
var cooldown = false
var bleed_dmg_modifier
var special = false
var num
var weapon = preload("res://Scenes/Weapon.tscn")

func _ready():
	
	num = 0
	
	anim_player = $AnimationPlayer
	
	player_invuln = false

	level_tilemap = GV.Scene["current_scene"].get_node("Level_TileMap")
	
	if level_tilemap == null:
		level_tilemap = $"/root/Main/Starting_World/Level_TileMap"
	
	hp = int(GV.GUI["GUI"].get_node("hp_num").text)
	
	mana_progress = GV.GUI["GUI"].get_node("mana_progress")
	
	if GV.Scene["current_scene"].has_node("Ammo_TileMap"):
		ammo_tilemap = GV.Scene["current_scene"].get_node("Ammo_TileMap")


func _physics_process(delta):
	
	player_movement()
	
	player_collision()
	
#	if Input.is_action_just_pressed("Inventory"):
#		if !GV.GUI["inventory"].visible:
#			GV.GUI["inventory"].visible = true
#		else:
#			GV.GUI["inventory"].visible = false
			
	if Input.is_action_just_pressed("stats"):
		if !GV.GUI["GUI"].get_node("gui_container").visible:
			GV.GUI["GUI"].get_node("gui_container").visible = true
		else:
			GV.GUI["GUI"].get_node("gui_container").visible = false

func player_movement():
	move_speed = GV.Player["player_move_speed"]
	var move_vec = Vector2()
	if Input.is_action_pressed("move_down"):
		self.get_node("Weapon").visible = false
		move_vec += Vector2.DOWN
		anim_player.play("walking_front")
		weapon_dir = "DOWN"
	if Input.is_action_pressed("move_up"):
		move_vec = Vector2.UP
		if !GV.Player["player_weapon"]:
			anim_player.play("walking_back")
		else:
			self.get_node("Weapon").visible = true
			self.get_node("Weapon").texture = ResourceLoader.load("res://Assets/items/" + GV.Player["player_weapon"] + ".png")
			anim_player.play("walking_back")
		weapon_dir = "UP"
	if Input.is_action_pressed("move_right"):
		self.get_node("Weapon").visible = false
		move_vec = Vector2.RIGHT
		$Body.set_flip_h(true)
		anim_player.play("walking_side")
		weapon_dir = "RIGHT"
	if Input.is_action_pressed("move_left"):
		self.get_node("Weapon").visible = false
		move_vec = Vector2.LEFT
		$Body.set_flip_h(false)
		anim_player.play("walking_side")
		weapon_dir = "LEFT"
	if move_vec == Vector2.ZERO:
		self.get_node("Weapon").visible = false
		is_moving = false
		anim_player.play("Idle")
	else:
		is_moving = true
	if Input.is_action_just_pressed("attack"):
		if GV.Player["player_weapon"] == "axe":
			if !attacking:
				axe_pos = - 28
				axe_dir = "y"
			elif attacking and axe_pos == - 28:
				axe_pos = + 25
				axe_dir = "x"
			elif attacking and axe_pos == + 25:
				axe_pos = + 40
				axe_dir = "y"
			elif attacking and axe_pos == + 40:
				axe_pos = -25
				axe_dir = "x"
				attacking = false
			else:
				axe_pos = - 28
				axe_dir = "y"
			weapon_attack(move_vec, axe_pos, axe_dir)
		else:
			if cooldown == false and GV.Item["current_ammo"] != "magic arrow":
				weapon_attack(move_vec, axe_pos, axe_dir)
				$attack_cooldown.start()
				cooldown = true
			elif GV.Item["current_ammo"] == "magic arrow":
				weapon_attack(move_vec, axe_pos, axe_dir)

	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * move_speed)
	
func _on_attack_cooldown_timeout():
	cooldown = false
	
func get_tile_name(coll, tilemap):
	var cell = tilemap.world_to_map(coll.position - coll.normal)
	var tile_id = tilemap.get_cellv(cell)
	var tile_name = coll.collider.tile_set.tile_get_name(tile_id)

	return [tile_name, tile_id]

func clear_tile(coll, tile_id):
	return coll.collider.tile_set.remove_tile(tile_id)

func player_collision():
	var coll = move_and_collide(Vector2() * move_speed)

	if coll:
		if coll.collider.name == "Shop_Entrance_Entry":
			GV.GUI["current_mana"] = GV.GUI["GUI"].get_node("mana_progress").get_node("mana_value").text
			GF.goto_scene("res://Scenes/Levels/Shop.tscn", "null")
#			GF.block_attribute_changes = true
			
		
		if coll.collider.name == "Level_TileMap":
			var level_tile_name = get_tile_name(coll, level_tilemap)[0]
	
			if level_tile_name == "shop_stairs_exit":
				GV.GUI["current_mana"] = GV.GUI["GUI"].get_node("mana_progress").get_node("mana_value").text
				GF.goto_scene("res://Scenes/Levels/Starting_World.tscn", "null")
#				GF.block_attribute_changes = true
#				
				

		if coll.collider.name == "Ammo_TileMap":
#			var test = get_tile_name(coll, ammo_tilemap)
			var ammo_tile_name = get_tile_name(coll, ammo_tilemap)[0]
			var cell = get_tile_name(coll, ammo_tilemap)[1]

#			if ammo_tile_name and GV.GUI["coins"] >= int(GV.Scene["current_scene"].get_node("ammo_price").text):
			GV.Item["current_ammo"] = ammo_tile_name
			GV.GUI["coins"] -= int(GV.Scene["current_scene"].get_node("ammo_price").text)
			GV.GUI["GUI"].get_node("coins").get_node("coins_num").text = str(GV.GUI["coins"])
			GV.Item["current_ammo_num"] = int(GV.Scene["current_scene"].get_node("ammo_capacity").text)
			GV.GUI["GUI"].get_node("ammo").text = ammo_tile_name
			GV.GUI["GUI"].get_node("ammo_num").text = GV.Scene["current_scene"].get_node("ammo_capacity").text
			GV.Scene["current_scene"].get_node("Ammo_TileMap").queue_free()
			GV.Scene["current_scene"].get_node("ammo_capacity").visible = false
			GV.Scene["current_scene"].get_node("ammo_capacity_two").visible = false
			GV.Scene["current_scene"].get_node("ammo_price").visible = false
			GV.Scene["current_scene"].get_node("ammo_price_two").visible = false
#			else:
#				print("notEnoughMuns")

#				weapon_achievement_anim(ammo_tile_name, coll, cell)
#				var weapon = ItemDB.WEAPON[ammo_tile_name]
#				weapon["id"] = GF.item_id
#				GF.item_id += 1
#				GF.inventory_items.push_front(weapon)
#				GV.GUI["inventory"].get_child(0).pickup_item(GF.inventory_items[0])
	
		if coll.collider.name == "camera_transition":
			var tween = get_node("Camera_Transition")
			self.get_parent().get_node("camera_transition/CollisionShape2D").disabled = true
			
			tween.interpolate_property($Camera2D, "limit_right",
			1124, 2248, 5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			
#			BUG: only triggers once. Maybe leave it this way bc it could be intentional this way (triggering the camera transition is a bit tedious) also enemies getting stuck in coll
			
		if "Snow" in coll.collider.name and player_invuln == false:
			GV.Enemy["enemy_dmg_type"] = "cold"
			snow_attack()
		elif "lightning" in coll.collider.name and player_invuln == false:
			loose_hp(GV.Enemy["enemy_dmg_modifier"])
		elif "Fire" in coll.collider.name and player_invuln == false:
			loose_hp(GV.Enemy["enemy_dmg_modifier"])
		elif "Starting" in coll.collider.name and player_invuln == false:
			GV.Enemy["enemy_dmg_type"] = "physical"
			loose_hp(GV.Enemy["enemy_dmg_modifier"])
				
		if "speed_up" in coll.collider.name:
			$pwr_up_timer.wait_time = 15
			$pwr_up_timer.start()
			self.move_speed += 1
			speed_up = true
			
			despawn_drop(coll)
			
		elif "muns" in coll.collider.name:
			GV.GUI["coins"] += 50
			GV.GUI["GUI"].get_node("coins").get_node("coins_num").text = str(GV.GUI["coins"])
			
			despawn_drop(coll)
			
		elif "all_attack" in coll.collider.name:
			$pwr_up_timer.wait_time = 15
			$pwr_up_timer.start()
			GV.Enemy["all_attack"] = true
			
			despawn_drop(coll)
			
		elif "invis" in coll.collider.name:
			player_invuln = true
			$invuln_timer.wait_time = 15
			$invuln_timer.start()
			
			despawn_drop(coll)
			
		elif "health_up" in coll.collider.name:
			hp += 25
			GV.GUI["GUI"].get_node("hp_num").text = str(hp)
			GV.Player["player_hp"] = hp
			
			despawn_drop(coll)

		elif "dmg_up" in coll.collider.name:
			$pwr_up_timer.wait_time = 15
			$pwr_up_timer.start()
			GV.Player["player_pwr"] += 25
			
			despawn_drop(coll)
			
		if "item" in coll.collider.name:
			for i in GV.Item["dropped_items"]:
				if i["id"] == int(coll.collider.get_node("id").text):
					GV.GUI["add_stats"] = true
					GV.Item["inventory_items"].push_front(i)
					GV.Item["dropped_items"].remove(GV.Item["dropped_items"].find(i))
					GV.GUI["inventory"].pickup_item(i)
					GV.GUI["add_stats"] = false

			GV.Scene["current_scene"].get_node(coll.collider.name).queue_free()
			
			if "Boss" in GV.Scene["current_scene"].name:
				GV.Item["ilvl"] -= 5
				GF.goto_scene("res://Scenes/pwr_up_screen.tscn", GV.Scene["current_scene"].name)
				
			
		if "proj" in coll.collider.name:
			for i in GV.Item["dropped_items"]:
				if i.name == coll.collider.name:
					GV.Item["inventory_items"].push_front(i)
					GV.Item["dropped_items"].remove(GV.Item["dropped_items"].find(i))
					GV.GUI["inventory"].pickup_item(i)

			GV.Scene["current_scene"].get_node(coll.collider.name).queue_free()
		
		if "Portal" in coll.collider.name:
			GV.GUI["current_mana"] = GV.GUI["GUI"].get_node("mana_progress").get_node("mana_value").text
			if "Starting" in GV.Scene["current_scene"].name:
				GV.Boss["load_boss"] = "Boss_slime"
			elif "jungle" in GV.Scene["current_scene"].name:
				GV.Boss["load_boss"] = "Boss_bow"
			else:
				GV.Boss["load_boss"] = "Boss_slime"
			GV.Item["ilvl"] += 10
			GF.goto_scene("res://Scenes/Levels/Boss_World.tscn", GV.Scene["current_scene"].name)
#			GF.block_attribute_changes = true
			GV.Scene["portal_spawned"] = false
			
func despawn_drop(coll):
	for i in GV.Item["dropped_items"]:
		if i["id"] == int(coll.collider.get_node("id").text):
			GV.Item["dropped_items"].remove(GV.Item["dropped_items"].find(i))

	GV.Scene["current_scene"].get_node(coll.collider.name).queue_free()
			
func snow_attack():
	loose_hp(GV.Enemy["enemy_dmg_modifier"])
	$freeze_timer.start()
	move_speed -= 1
	
func _on_freeze_timer_timeout():
	move_speed += 1

func _on_poison_timer_timeout():
	for i in self.get_children():
		if "poison_dmg_timer" in i.name:
			i.queue_free()
	
func _on_poison_dmg_timer_timeout(tick):
	if $poison_timer.time_left != 0:
		loose_hp(GV.Enemy["enemy_dmg_modifier"]/2)

func _on_bleed_timer_timeout():
	for i in self.get_children():
		if "bleed_dmg_timer" in i.name:
			i.queue_free()

func bleed_damage(modifier):
	bleed_dmg_modifier = modifier
	print("playertakesBleedDmg")
	self.get_node("bleed_timer").start()
	var bleed_dmg_timer = Timer.new()
	bleed_dmg_timer.name = "bleed_dmg_timer"
	bleed_dmg_timer.connect("timeout", GV.Player["player"], "_on_bleed_dmg_timer_timeout")
	self.add_child(bleed_dmg_timer)
	self.get_node(bleed_dmg_timer.name).start()
	
func _on_bleed_dmg_timer_timeout():
	if is_moving:
		loose_hp(GV.Enemy["enemy_dmg_modifier"]/bleed_dmg_modifier)
	else: 
		loose_hp((GV.Enemy["enemy_dmg_modifier"]/2)/bleed_dmg_modifier)
		
func resistance_damage_calc(value):
	if GV.Enemy["enemy_dmg_type"] == "fire":
		value -= (GV.Player.player_resistance["fire"]/2)
	elif GV.Enemy["enemy_dmg_type"] == "cold":
		value -= (GV.Player.player_resistance["cold"]/2)
	elif GV.Enemy["enemy_dmg_type"] == "lightning":
		value -= (GV.Player.player_resistance["lightning"]/2)
	elif GV.Enemy["enemy_dmg_type"] == "poison":
		value -= (GV.Player.player_resistance["poison"]/2)
	elif GV.Enemy["enemy_dmg_type"] == "physical":
		value -= (GV.Player.player_resistance["physical"]/2)
	else:
		return value
	return value

func loose_hp(value):
	var res_value = resistance_damage_calc(value)
	print("dmgTaken ", res_value)
	GV.GUI["GUI"].get_node("hp_visual").value -= res_value
	GV.Player["player_hp"] -= res_value
	GV.GUI["GUI"].get_node("hp_num").text = str(GV.Player["player_hp"])
	
#	self.visible = false
	player_invuln = true
	$invuln_timer.wait_time = 1
	$invuln_timer.start()
	if GV.GUI["GUI"].get_node("hp_num").text <= str(0):
		GF.goto_scene("res://Scenes/game_over_screen.tscn", "null")
	
func _on_pwr_up_timer_timeout():
	if GV.Enemy["all_attack"]:
		GV.Enemy["all_attack"] = false
	elif speed_up:
		self.move_speed -= 1
		speed_up = false
	elif dmg_up:
		GV.Player["player_pwr"] -= 25
		dmg_up = false

func _on_invuln_timer_timeout():
#	self.visible = true
	player_invuln = false

func _on_mana_fill_timer_timeout():
	if mana_progress.value != mana_progress.max_value: 
		mana_progress.value += mana_progress.step
		mana_progress.get_node("mana_value").text = str(mana_progress.value)
	else:
		$mana_fill_timer.stop()
		
func _on_life_fill_timer_timeout():
	if GV.GUI["GUI"].get_node("hp_visual").value != GV.GUI["GUI"].get_node("hp_visual").max_value: 
		GV.GUI["GUI"].get_node("hp_visual").value += GV.GUI["GUI"].get_node("hp_visual").step
		GV.Player["player_hp"] += GV.GUI["GUI"].get_node("hp_visual").step
		GV.GUI["GUI"].get_node("hp_num").text = str(GV.GUI["GUI"].get_node("hp_visual").value)
		num +=1
#	else:
#		$life_fill_timer.stop()

#currently not in use
func weapon_achievement_anim(weapons_tile_name, coll, cell):
		clear_tile(coll, cell)

		var weapon_sprite = load("res://Scenes/weapons/" + weapons_tile_name + ".tscn").instance()
		add_child(weapon_sprite)
		weapon_sprite.position.y -= 32
		anim_player.play("get_wep")
		yield(get_tree().create_timer(0.01), "timeout")
		get_tree().paused = true
		yield(get_tree().create_timer(2), "timeout")
		get_tree().paused = false

		weapon_sprite.queue_free()

		GV.Scene["current_scene"].get_node("Weapons_TileMap").queue_free()
	
func weapon_attack(move_vec, axe_pos, axe_dir):
	attacking = true
	
	if GV.Player["player_weapon"]:
		var weapon = load("res://Scenes/Weapon.tscn").instance()

		if GV.Player["player_weapon"] == "axe":
			GV.Scene["current_scene"].get_node("Player").add_child(weapon)
			var axe = load("res://Assets/axe_small.png")
			
			if axe_dir == "y":
				weapon.position.y = axe_pos
			else:
				weapon.position.x = axe_pos
			
			weapon.get_node("weapon").set_texture(axe)
			weapon.speed = 0
			weapon.get_node("AnimationPlayer").play("axe_swirl")

		if GV.Player["player_weapon"] == "bow": 
			if special:
					weapon.special = special
			GV.Scene["current_scene"].add_child(weapon)
			weapon.position = self.position
			var arrow = load("res://Assets/arrow.png")
			if GV.Item["current_ammo"] != null and GV.Item["current_ammo_num"] != 0:
				var special_arrow = load("res://Assets/ammo_" + GV.Item["current_ammo"] + ".png")
				weapon.get_node("weapon").set_texture(special_arrow)
				weapon.get_node("weapon").rotation_degrees = -45
				GV.Item["current_ammo_num"] -= 1
				GV.GUI["GUI"].get_node("ammo_num").text = str(GV.Item["current_ammo_num"])
				if GV.Item["current_ammo_num"] == 0:
					GV.Item["current_ammo"] = "standard arrow"
					GV.GUI["GUI"].get_node("ammo").text = "standard arrow"
#				ammo -= 1
			else:
				weapon.get_node("weapon").set_texture(arrow)
			if weapon_dir == "DOWN":  #or move_vec == Vector2.ZERO:
				weapon.rotation_degrees = -90
				weapon.velocity = Vector2.DOWN
			elif weapon_dir == "UP":
				weapon.rotation_degrees = 90
				weapon.velocity = Vector2.UP
			elif weapon_dir == "RIGHT":
				weapon.rotation_degrees = 180
				weapon.velocity = Vector2.RIGHT
			elif weapon_dir == "LEFT":
				weapon.rotation_degrees = 0
				weapon.velocity = Vector2.LEFT
		
		if GV.Player["player_weapon"] == "wand":
			var wand
			var mana_cost = 10
			if mana_progress.value > mana_cost:
				GV.Scene["current_scene"].add_child(weapon)
				weapon.position = self.position
				if special:
					if special == "multi_proj":
						spec_mod_wand_multi_proj(wand)
					if special == "speed_proj":
						spec_mod_wand_speed(weapon)
				if GV.Weapon["wand_proj"] != null:
					wand = load("res://Assets/" + GV.Weapon["wand_proj"] + ".png")
					if "fire" in GV.Weapon["wand_proj"]: 
						weapon.get_node("AnimationPlayer").play("fireball")
					elif "beam" in GV.Weapon["wand_proj"]:
						weapon.get_node("weapon_coll").shape = RectangleShape2D.new()
						weapon.get_node("weapon_coll").shape.extents.y = 822
						weapon.get_node("AnimationPlayer").play("beam")
						if weapon_dir == "RIGHT":
							weapon.position.x += 840
							weapon.rotation_degrees = 45
						elif weapon_dir == "LEFT":
							weapon.position.x -= 840
							weapon.rotation_degrees = 45
						elif weapon_dir == "UP":
							weapon.position.y -= 840
							weapon.rotation_degrees = -45
						elif weapon_dir == "DOWN":
							weapon.position.y += 840
							weapon.rotation_degrees = -45
				else:
					wand = load("res://Assets/wand_attack.png")
				mana_progress.value -= mana_cost
				mana_progress.get_node("mana_value").text = str(mana_progress.value)
				weapon.get_node("weapon").set_texture(wand)
				var shortest_distance_enemy = GV.Scene["current_scene"].get_node("Level_TileMap")
				if GV.Scene["current_scene"].name != "Shop":
					if GV.Enemy["enemy_entites"].size() > 0:
						for i in GV.Enemy["enemy_entites"]:
							var distance_to_player = i.get_global_position().distance_to(self.get_global_position())
							if distance_to_player < shortest_distance_enemy.get_global_position().distance_to(self.get_global_position()):
								shortest_distance_enemy = i
							var dir = weapon.position.direction_to(GV.Scene["current_scene"].get_node(shortest_distance_enemy.name).position)
							weapon.velocity = Vector2.move_toward(dir, weapon.speed)
					else:
						print("cannot fire in shop")
				else:
					print("oom")
		if GV.Player["player_weapon"] == "staff":
			GV.Scene["current_scene"].get_node("Player").add_child(weapon)
			var staff = load("res://Assets/staff_attack.png")
			weapon.get_node("weapon").set_texture(staff)
			weapon.get_node("weapon_coll").scale.y = 3
			weapon.get_node("AnimationPlayer").play("staff_attack")
	
	if mana_progress.value != mana_progress.max_value:
		$mana_fill_timer.start()
	else:
		$mana_fill_timer.stop()
		
func spec_mod_wand_multi_proj(wand):
	wand = load("res://Assets/wand_attack.png")
	
	var multi_proj_one = load("res://Scenes/Weapon.tscn").instance()
	var multi_proj_two = load("res://Scenes/Weapon.tscn").instance()
	
	var multi_projs = [multi_proj_one, multi_proj_two]
	
	for i in multi_projs:
		GV.Scene["current_scene"].add_child(i)
		i.get_node("weapon").set_texture(wand)
		i.position = self.position
	
	if $Body.is_flipped_h():
		multi_proj_one.velocity = Vector2(1,0).rotated(-75)
		multi_proj_two.velocity = Vector2(1,0).rotated(75)
	else:
		multi_proj_one.velocity = Vector2(-1,0).rotated(-75)
		multi_proj_two.velocity = Vector2(-1,0).rotated(75)
		
func spec_mod_wand_speed(weapon):
	weapon.speed += weapon.speed


