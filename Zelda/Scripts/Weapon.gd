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
			body.set_script(load("res://Scripts/attack_movement.gd"))
		var lvl_progress = Globals.GUI.get_node("lvl_progress")
		var enemy_hp_bar = body.get_node("enemy_hp_bar")
		var original_player_pwr = Globals.player_pwr
		for j in Globals.inventory_items:
			if j["name"] == Globals.player_weapon:
				Globals.player_pwr -= (Globals.enemy_resistance[j["dmg"]]/10)
		for i in Globals.enemy_pos.size():
			if str(body) == Globals.enemy_id[i]:
				if "axe" in self.get_node("weapon").texture.get_path():
					Globals.enemy_hp[i] -= (Globals.player_pwr*2)
				else: 
					Globals.enemy_hp[i] -= Globals.player_pwr
				enemy_hp_bar.visible = true	
				enemy_hp_bar.value -= Globals.player_pwr
				Globals.player_pwr = original_player_pwr
				if Globals.enemy_hp[i] <= 0:
					Globals.enemy_id.remove(i)
					Globals.enemy_pos.remove(i)
					Globals.enemy_hp.remove(i)
					Globals.enemies.remove(i)
					Globals.enemy_tracker -= 1
					Globals.drop(body.position)
					Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)
					if lvl_progress.value == (lvl_progress.max_value-lvl_progress.step):
						var curr_lvl = int(Globals.GUI.get_node("lvl").text)
						curr_lvl += 1
						Globals.GUI.get_node("lvl").text = str(curr_lvl)
						Globals.player_lvl = curr_lvl
						lvl_progress.value = 0
						Globals.current_scene.get_node("GUI").get_node("lvl_up").visible = true
						var lvlupstats = int(Globals.current_scene.get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text) 
						lvlupstats += 5
						Globals.current_scene.get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text = str(lvlupstats)
						if Globals.player_lvl%2 == 0 and Globals.player_lvl != 0:
							pass
#							Globals.player_pwr += 50
					else:
						lvl_progress.value += lvl_progress.step
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

func _on_Weapon_Timeout_timeout():
	self.queue_free()

