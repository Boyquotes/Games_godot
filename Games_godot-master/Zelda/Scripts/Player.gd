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

var weapon = preload("res://Scenes/Weapon.tscn")

func _ready():
	
	anim_player = $AnimationPlayer
	
	player_invuln = false

	level_tilemap = Globals.current_scene.get_node("Level_TileMap")
	
	hp = int(Globals.GUI.get_node("hp_num").text)
	
	mana_progress = Globals.GUI.get_node("mana_progress")
	
	if Globals.current_scene.has_node("Ammo_TileMap"):
		ammo_tilemap = Globals.current_scene.get_node("Ammo_TileMap")

	if level_tilemap == null:
			level_tilemap = $"/root/Main/Starting_World/Level_TileMap"

func _physics_process(delta):
	
	player_movement()
	
	player_collision()
	
	if Input.is_action_just_pressed("Inventory"):
		if !Globals.inventory.visible:
			Globals.inventory.visible = true
		else:
			Globals.inventory.visible = false
			
	if Input.is_action_just_pressed("stats"):
		if !Globals.GUI.get_node("stat_container").visible:
			Globals.GUI.get_node("stat_container").visible = true
		else:
			Globals.GUI.get_node("stat_container").visible = false

func player_movement():
	move_speed = Globals.player_move_speed
	var move_vec = Vector2()
	if Input.is_action_pressed("move_down"):
		move_vec += Vector2.DOWN
		anim_player.play("walking_front")
		weapon_dir = "DOWN"
	if Input.is_action_pressed("move_up"):
		move_vec = Vector2.UP
		if !Globals.player_weapon:
			anim_player.play("walking_back")
		else:
			anim_player.play(Globals.player_weapon + "_back")
		weapon_dir = "UP"
	if Input.is_action_pressed("move_right"):
		move_vec = Vector2.RIGHT
		$Body.set_flip_h(true)
		anim_player.play("walking_side")
		weapon_dir = "RIGHT"
	if Input.is_action_pressed("move_left"):
		move_vec = Vector2.LEFT
		$Body.set_flip_h(false)
		anim_player.play("walking_side")
		weapon_dir = "LEFT"
	if move_vec == Vector2.ZERO:
		is_moving = false
		anim_player.play("Idle")
	else:
		is_moving = true
	if Input.is_action_just_pressed("attack"):
		if Globals.player_weapon == "axe":
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
			if cooldown == false and Globals.current_ammo != "magic arrow":
				weapon_attack(move_vec, axe_pos, axe_dir)
				$attack_cooldown.start()
				cooldown = true
			elif Globals.current_ammo == "magic arrow":
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
			Globals.current_mana = Globals.GUI.get_node("mana_progress").get_node("mana_value").text
			Globals.goto_scene("res://Scenes/Levels/Shop.tscn", "null")
		
		if coll.collider.name == "Level_TileMap":
			var level_tile_name = get_tile_name(coll, level_tilemap)[0]
	
			if level_tile_name == "shop_stairs_exit":
				Globals.current_mana = Globals.GUI.get_node("mana_progress").get_node("mana_value").text
				Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn", "null")
				

		if coll.collider.name == "Ammo_TileMap":
#			var test = get_tile_name(coll, ammo_tilemap)
			var ammo_tile_name = get_tile_name(coll, ammo_tilemap)[0]
			var cell = get_tile_name(coll, ammo_tilemap)[1]

#			if ammo_tile_name and Globals.coins >= int(Globals.current_scene.get_node("ammo_price").text):
			Globals.current_ammo = ammo_tile_name
			Globals.coins -= int(Globals.current_scene.get_node("ammo_price").text)
			Globals.GUI.get_node("coins").get_node("coins_num").text = str(Globals.coins)
			Globals.current_ammo_num = int(Globals.current_scene.get_node("ammo_capacity").text)
			Globals.GUI.get_node("ammo").text = ammo_tile_name
			Globals.GUI.get_node("ammo_num").text = Globals.current_scene.get_node("ammo_capacity").text
			Globals.current_scene.get_node("Ammo_TileMap").queue_free()
			Globals.current_scene.get_node("ammo_capacity").visible = false
			Globals.current_scene.get_node("ammo_capacity_two").visible = false
			Globals.current_scene.get_node("ammo_price").visible = false
			Globals.current_scene.get_node("ammo_price_two").visible = false
#			else:
#				print("notEnoughMuns")

#				weapon_achievement_anim(ammo_tile_name, coll, cell)
#				var weapon = ItemDB.WEAPON[ammo_tile_name]
#				weapon["id"] = Globals.item_id
#				Globals.item_id += 1
#				Globals.inventory_items.push_front(weapon)
#				Globals.inventory.get_child(0).pickup_item(Globals.inventory_items[0])
	
		if coll.collider.name == "camera_transition":
			var tween = get_node("Camera_Transition")
			self.get_parent().get_node("camera_transition/CollisionShape2D").disabled = true
			
			tween.interpolate_property($Camera2D, "limit_right",
			1124, 2248, 5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			
#			BUG: only triggers once. Maybe leave it this way bc it could be intentional this way (triggering the camera transition is a bit tedious) also enemies getting stuck in coll
			
		if "Snow" in coll.collider.name and player_invuln == false:
			Globals.damage_type = "cold"
			snow_attack()
		elif "lightning" in coll.collider.name and player_invuln == false:
			loose_hp(Globals.enemy_dmg_modifier)
		elif "Fire" in coll.collider.name and player_invuln == false:
			loose_hp(Globals.enemy_dmg_modifier)
		elif "Starting" in coll.collider.name and player_invuln == false:
			Globals.damage_type = "physical"
			loose_hp(Globals.enemy_dmg_modifier)
				
		if "speed_up" in coll.collider.name:
			$pwr_up_timer.wait_time = 15
			$pwr_up_timer.start()
			self.move_speed += 1
			speed_up = true
			
			despawn_drop(coll)
			
		elif "muns" in coll.collider.name:
			Globals.coins += 50
			Globals.GUI.get_node("coins").get_node("coins_num").text = str(Globals.coins)
			
			despawn_drop(coll)
			
		elif "all_attack" in coll.collider.name:
			$pwr_up_timer.wait_time = 15
			$pwr_up_timer.start()
			Globals.all_attack = true
			
			despawn_drop(coll)
			
		elif "invis" in coll.collider.name:
			player_invuln = true
			$invuln_timer.wait_time = 15
			$invuln_timer.start()
			
			despawn_drop(coll)
			
		elif "health_up" in coll.collider.name:
			hp += 25
			Globals.GUI.get_node("hp_num").text = str(hp)
			Globals.player_hp = hp
			
			despawn_drop(coll)

		elif "dmg_up" in coll.collider.name:
			$pwr_up_timer.wait_time = 15
			$pwr_up_timer.start()
			Globals.player_pwr += 25
			
			despawn_drop(coll)
			
		if "item" in coll.collider.name:
			for i in Globals.dropped_items:
				if i["id"] == int(coll.collider.get_node("id").text):
					Globals.inventory_items.push_front(i)
					Globals.dropped_items.remove(Globals.dropped_items.find(i))
					Globals.inventory.get_child(0).pickup_item(i)

			Globals.current_scene.get_node(coll.collider.name).queue_free()
			
			if "Boss" in Globals.current_scene.name:
				Globals.goto_scene("res://Scenes/pwr_up_screen.tscn", Globals.current_scene.name)
			
		if "proj" in coll.collider.name:
			for i in Globals.dropped_items:
				if i.name == coll.collider.name:
					Globals.inventory_items.push_front(i)
					Globals.dropped_items.remove(Globals.dropped_items.find(i))
					Globals.inventory.get_child(0).pickup_item(i)

			Globals.current_scene.get_node(coll.collider.name).queue_free()
		
		if "Portal" in coll.collider.name:
			Globals.current_mana = Globals.GUI.get_node("mana_progress").get_node("mana_value").text
			if "Starting" in Globals.current_scene.name:
				Globals.load_boss = "Boss_scythe"
			elif "jungle" in Globals.current_scene.name:
				Globals.load_boss = "Boss_bow"
			else:
				Globals.load_boss = "Boss_slime"
			Globals.goto_scene("res://Scenes/Levels/Boss_Room.tscn", Globals.current_scene.name)
			Globals.entities.clear()
			Globals.entities.push_front(Globals.enemies)
			Globals.portal_spawned = false
			
func despawn_drop(coll):
	for i in Globals.dropped_items:
		if i["id"] == int(coll.collider.get_node("id").text):
			Globals.dropped_items.remove(Globals.dropped_items.find(i))

	Globals.current_scene.get_node(coll.collider.name).queue_free()
			
func snow_attack():
	loose_hp(Globals.enemy_dmg_modifier)
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
		loose_hp(Globals.enemy_dmg_modifier/2)

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
	bleed_dmg_timer.connect("timeout", Globals.player, "_on_bleed_dmg_timer_timeout")
	self.add_child(bleed_dmg_timer)
	self.get_node(bleed_dmg_timer.name).start()
	
func _on_bleed_dmg_timer_timeout():
	if is_moving:
		loose_hp(Globals.enemy_dmg_modifier/bleed_dmg_modifier)
	else: 
		loose_hp((Globals.enemy_dmg_modifier/2)/bleed_dmg_modifier)
		
func resistance_damage_calc(value):
	if Globals.damage_type == "fire":
		value -= (Globals.player_resistance["fire"]/2)
	elif Globals.damage_type == "cold":
		value -= (Globals.player_resistance["cold"]/2)
	elif Globals.damage_type == "lightning":
		value -= (Globals.player_resistance["lightning"]/2)
	elif Globals.damage_type == "poison":
		value -= (Globals.player_resistance["poison"]/2)
	elif Globals.damage_type == "physical":
		value -= (Globals.player_resistance["physical"]/2)
	else:
		return value
	return value

func loose_hp(value):
	var res_value = resistance_damage_calc(value)
	print("dmgTaken ", res_value)
	Globals.GUI.get_node("hp_visual").value -= res_value
	Globals.player_hp -= res_value
	Globals.GUI.get_node("hp_num").text = str(Globals.player_hp)
	
#	self.visible = false
	player_invuln = true
	$invuln_timer.wait_time = 1
	$invuln_timer.start()
	if Globals.GUI.get_node("hp_num").text <= str(0):
		Globals.goto_scene("res://Scenes/game_over_screen.tscn", "null")
	
func _on_pwr_up_timer_timeout():
	if Globals.all_attack:
		Globals.all_attack = false
	elif speed_up:
		self.move_speed -= 1
		speed_up = false
	elif dmg_up:
		Globals.player_pwr -= 25
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

		Globals.current_scene.get_node("Weapons_TileMap").queue_free()
	
func weapon_attack(move_vec, axe_pos, axe_dir):
	attacking = true
	
	if Globals.player_weapon:
		var weapon = load("res://Scenes/Weapon.tscn").instance()

		if Globals.player_weapon == "axe":
			Globals.current_scene.get_node("Player").add_child(weapon)
			var axe = load("res://Assets/axe_small.png")
			
			if axe_dir == "y":
				weapon.position.y = axe_pos
			else:
				weapon.position.x = axe_pos
			
			weapon.get_node("weapon").set_texture(axe)
			weapon.speed = 0
			weapon.get_node("AnimationPlayer").play("axe_swirl")

		if Globals.player_weapon == "bow": 
			Globals.current_scene.add_child(weapon)
			weapon.position = self.position
			var arrow = load("res://Assets/arrow.png")
			if Globals.current_ammo != null and Globals.current_ammo_num != 0:
				var special_arrow = load("res://Assets/ammo_" + Globals.current_ammo + ".png")
				weapon.get_node("weapon").set_texture(special_arrow)
				weapon.get_node("weapon").rotation_degrees = -45
				Globals.current_ammo_num -= 1
				Globals.GUI.get_node("ammo_num").text = str(Globals.current_ammo_num)
				if Globals.current_ammo_num == 0:
					Globals.current_ammo = "standard arrow"
					Globals.GUI.get_node("ammo").text = "standard arrow"
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
		
		if Globals.player_weapon == "wand":
			var wand
			var mana_cost = 10
			if mana_progress.value > mana_cost:
				Globals.current_scene.add_child(weapon)
				weapon.position = self.position
				if Globals.wand_proj != null:
					wand = load("res://Assets/" + Globals.wand_proj + ".png")
					if "fire" in Globals.wand_proj: 
						weapon.get_node("AnimationPlayer").play("fireball")
					elif "beam" in Globals.wand_proj:
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
				var shortest_distance_enemy = Globals.current_scene.get_node("Level_TileMap")
				if Globals.current_scene.name != "Shop":
					for i in Globals.entities:
						var distance_to_player = i.get_global_position().distance_to(self.get_global_position())
						if distance_to_player < shortest_distance_enemy.get_global_position().distance_to(self.get_global_position()):
							shortest_distance_enemy = i
						var dir = weapon.position.direction_to(Globals.current_scene.get_node(shortest_distance_enemy.name).position)
						weapon.velocity = Vector2.move_toward(dir, weapon.speed)
				else:
					print("cannot fire in shop")
			else:
				print("oom")
			
		if Globals.player_weapon == "staff":
			Globals.current_scene.get_node("Player").add_child(weapon)
			var staff = load("res://Assets/staff_attack.png")
			weapon.get_node("weapon").set_texture(staff)
			weapon.get_node("weapon_coll").scale.y = 3
			weapon.get_node("AnimationPlayer").play("staff_attack")
	
	if mana_progress.value != mana_progress.max_value:
		$mana_fill_timer.start()
	else:
		$mana_fill_timer.stop()
				
				

