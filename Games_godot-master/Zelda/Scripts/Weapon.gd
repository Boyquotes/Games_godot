extends Area2D

var speed = 3.5
var velocity = Vector2.ZERO
var life_time = 3
var beam_timer
var beam_dmg = false
var enemy_hp_bar
var dmg_taken
var curr_enemy

func _ready():
	if Globals.wand_proj == "wand_beam_proj":
		life_time = 3
		
	$Weapon_Timeout.set_wait_time(life_time)
	$Weapon_Timeout.start()
	
func _physics_process(delta):
	if Globals.wand_proj != "wand_beam_proj":
		position += velocity * speed

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if Globals.wand_proj == "wand_beam_proj" and "Level_TileMap" in body.name:
		self.show_behind_parent == true
		
	elif Globals.player_weapon == "bow" and "Enemy" in body.name or "Level_TileMap" in body.name or Globals.player_weapon == "wand" and Globals.wand_proj != "wand_beam_proj" and "Enemy" in body.name or "Level_TileMap" in body.name:
		self.queue_free()
	
	if "Enemy" in body.name:
		if "Starting" in body.name:
			body.enemy_attack = true
		var lvl_progress = Globals.GUI.get_node("lvl_progress")
		enemy_hp_bar = body.get_node("enemy_hp_bar")
		var original_player_pwr = Globals.player_pwr
		dmg_taken = dmg_calc()
#		
		for i in Globals.enemy_pos.size():
			if str(body) == Globals.enemy_id[i]:
				enemy_hp_bar.visible = true
				
				if Globals.current_ammo:
					if Globals.current_ammo == "frost arrow":
						body.move_speed = 0.5
						body.unfreeze_timer(i)
					elif Globals.current_ammo == "fire arrow": 
						body.burn_timer(i, dmg_taken)
					elif Globals.current_ammo == "lightning arrow":
						body.shock_timer(i, dmg_taken)
					elif Globals.current_ammo == "poison arrow":
						body.poison_timer(i, dmg_taken)
					elif Globals.current_ammo == "web arrow":
						var spider_web = ResourceLoader.load("res://Scenes/spider_web.tscn").instance()
						Globals.current_scene.call_deferred("add_child", spider_web)
						spider_web.position = body.position
						Globals.enemy_hp[i] -= dmg_taken
						enemy_hp_bar.value -= dmg_taken
					else:
						Globals.enemy_hp[i] -= dmg_taken
						enemy_hp_bar.value -= dmg_taken
				elif Globals.player_weapon == "wand":
					if Globals.wand_proj == null:
						Globals.enemy_hp[i] -= dmg_taken
						enemy_hp_bar.value -= dmg_taken
					elif Globals.wand_proj == "fire_one":
						print("enemey ",i)
						body.burn_timer(i, (dmg_taken*1.5))
					elif Globals.wand_proj == "wand_beam_proj":
						$Beam_Timer.start()
						$Beam_Timer.one_shot = false
						beam_dmg = true
						curr_enemy = i
				else:
					Globals.enemy_hp[i] -= dmg_taken
					enemy_hp_bar.value -= dmg_taken
					
				if Globals.enemy_hp[i] <= 0:
					body.remove_enemy(i)
					body.queue_free()
					if Globals.enemy_tracker == 0:
						print("spawn boss portal")
						Globals.spawn_boss_portal()
						return
					break
						
				Globals.player_pwr = original_player_pwr

			Globals.player_xp = lvl_progress.value

		if Globals.enemy_tracker == 2 and !Globals.shop_spawned:
			Globals.spawn_weapon_shop()
			Globals.shop_spawned = true
			
#		if Globals.enemy_tracker == 0:
#			print("spawn boss portal")
#			Globals.spawn_boss_portal()
#			return

	if "Boss_Portal" in body.name:
		var boss_portal_health = 150
		var boss_portal_health_bar = body.get_node("Boss_Portal_HP")
		boss_portal_health_bar.visible = true
		self.queue_free()
		boss_portal_health -= 50
		boss_portal_health_bar.value -= 50
		
		if boss_portal_health_bar.value <= 0:
			body.queue_free()
			Globals.num_of_enemies(5)
			Globals.spawn_enemy_type()
#			Globals.enemy_tracker = Globals.enemy_pos.size()
			Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)

	if "boss" in body.name:
		Globals.all_attack = false
		Globals.boss.queue_free()
		Globals.current_mana = Globals.GUI.get_node("mana_progress").get_node("mana_value").text
		Globals.num_of_enemies(5)
		Globals.goto_scene("res://Scenes/Levels/" + Globals.next_scene + ".tscn", Globals.current_scene.name)
		Globals.ilvl += 10
		Globals.enemy_hp_value += 50
		
#		goto powerup screen?
#		next lvl
#		Globals.goto_scene("res://Scenes/game_won_screen.tscn", "null")
#		Globals.num_of_enemies(1)

func dmg_calc():
	var dmg = Globals.player_pwr
	for j in Globals.GUI.get_node("stat_container").get_node("dmg").get_children():
		for k in Globals.enemy_resistance:
			if j.text == k and int(j.get_child(0).text) > 0:
				dmg -= Globals.enemy_resistance.get(k)
	print("dmg ",dmg)
#	print("weapon ",Globals.player_weapon)
#	print("proj ",Globals.wand_proj)
	return dmg

func _on_Beam_Timer_timeout():
	Globals.enemy_hp[curr_enemy] -= dmg_taken
	enemy_hp_bar.value -= dmg_taken

func _on_Weapon_Timeout_timeout():
	self.queue_free()

func _on_weapon_body_shape_exited(body_id, body, body_shape, local_shape):
	if beam_dmg:
		$Beam_Timer.stop()
		beam_dmg = false
	else:
		return
