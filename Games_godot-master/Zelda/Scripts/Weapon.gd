extends Area2D

var speed = 3.5
var velocity = Vector2.ZERO
var life_time = 3

func _ready():
	if Globals.player_weapon == "axe":
		life_time = 1
		
	$Weapon_Timeout.set_wait_time(life_time)
	$Weapon_Timeout.start()
	
func _physics_process(delta):
	position += velocity * speed

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if Globals.player_weapon == "bow" and "Enemy" in body.name or "Level_TileMap" in body.name or Globals.player_weapon == "wand" and "Enemy" in body.name or "Level_TileMap" in body.name:
		self.queue_free()
	
	if "Enemy" in body.name:
		if "Starting" in body.name:
			body.enemy_attack = true
		var lvl_progress = Globals.GUI.get_node("lvl_progress")
		var enemy_hp_bar = body.get_node("enemy_hp_bar")
		var original_player_pwr = Globals.player_pwr
		var dmg_taken = dmg_calc()
#		
		for i in Globals.enemy_pos.size():
			if str(body) == Globals.enemy_id[i]:
#				if "axe" in self.get_node("weapon").texture.get_path():
#					Globals.enemy_hp[i] -= (Globals.player_pwr*2)
				if "arrow" in Globals.current_ammo:
					if Globals.current_ammo == "frost arrow":
						body.move_speed = 0.5
						body.unfreeze_timer()
					elif Globals.current_ammo == "fire arrow": 
						body.burn_timer(i, dmg_taken)
					elif Globals.current_ammo == "lightning arrow":
						body.shock_timer(i, dmg_taken)
					elif Globals.current_ammo == "poison arrow":
						body.poison_timer(i, dmg_taken)
					else:
						Globals.enemy_hp[i] -= dmg_taken
						enemy_hp_bar.value -= dmg_taken
					enemy_hp_bar.visible = true
					Globals.player_pwr = original_player_pwr
					if Globals.enemy_hp[i] <= 0:
						body.remove_enemy(i)
						body.queue_free()
						break

				Globals.player_xp = lvl_progress.value

		if Globals.enemy_tracker == Globals.enemy_num - 2 and !Globals.shop_spawned:
			Globals.spawn_weapon_shop()
			Globals.shop_spawned = true
			
		if Globals.enemy_tracker == 0:
			print("spawn boss")
			Globals.boss = ResourceLoader.load("res://Scenes/boss.tscn").instance()
			Globals.boss.position.x = 500
			Globals.boss.position.y = 250
			Globals.current_scene.call_deferred("add_child", Globals.boss)
			if "Jungle" in Globals.current_scene.name:
				print("jungleBOSS")
			return

	if "boss" in body.name:
		Globals.all_attack = false
		Globals.boss.queue_free()
		Globals.current_mana = Globals.GUI.get_node("mana_progress").get_node("mana_value").text
		Globals.goto_scene("res://Scenes/Levels/" + Globals.next_scene + ".tscn", Globals.current_scene.name)
		Globals.num_of_enemies(2)
		
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
	return dmg

func _on_Weapon_Timeout_timeout():
	self.queue_free()

