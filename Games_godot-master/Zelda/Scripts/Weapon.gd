extends Area2D

var speed = 3.5
var velocity = Vector2.ZERO
var life_time = 3
var beam_timer
var beam_dmg = false
var enemy_hp_bar
var dmg_taken
var special
var shop_spawned = false

var dmg_floating_txt = preload("res://Scenes/Floating_dmg_num.tscn")


func _ready():
	if GV.Weapon["wand_proj"] == "wand_beam_proj":
		life_time = 3
		
	$Weapon_Timeout.set_wait_time(life_time)
	$Weapon_Timeout.start()
	
func _physics_process(delta):
	if GV.Weapon["wand_proj"] != "wand_beam_proj":
		position += velocity * speed

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name != "Player" and GV.Weapon["wand_proj"] != "wand_beam_proj":
		self.queue_free()
	if GV.Weapon["wand_proj"] == "wand_beam_proj" and "Level_TileMap" in body.name:
		self.show_behind_parent == true
	
	if "Enemy" in body.name or "Boss" in body.name:
		if "Starting" in body.name:
			body.enemy_attack = true
		var lvl_progress = GV.GUI["GUI"].get_node("lvl_progress")
		enemy_hp_bar = body.get_node("hp_bar")
		var original_player_pwr = GV.Player["player_pwr"]
		dmg_taken = dmg_calc()
#		
		for i in GV.Enemy["enemy_entites"].size():
			if str(body) == GV.Enemy["enemy_id"][i]:
				enemy_hp_bar.visible = true
				if GV.Item["current_ammo"]:
					if special:
						print("special ", special)
					
					if GV.Item["current_ammo"] == "frost arrow":
						body.move_speed = 0.5
						body.unfreeze_timer(i)
					elif GV.Item["current_ammo"] == "fire arrow": 
						body.burn_timer(i, dmg_taken, 2)
					elif GV.Item["current_ammo"] == "lightning arrow":
						body.shock_timer(i, dmg_taken)
					elif GV.Item["current_ammo"] == "poison arrow":
						body.poison_timer(i, dmg_taken)
					elif GV.Item["current_ammo"] == "web arrow":
						var spider_web = ResourceLoader.load("res://Scenes/spider_web.tscn").instance()
						GV.Scene["current_scene"].call_deferred("add_child", spider_web)
						spider_web.position = body.position
						enemy_dmg_taken(i, body)
					else:
						enemy_dmg_taken(i, body)
				elif GV.Player["player_weapon"] == "wand":
					if GV.Weapon["wand_proj"] == null:
						enemy_dmg_taken(i, body)
					elif GV.Weapon["wand_proj"] == "fire_one":
						if body.burning != true:
							body.burn_timer(i, (dmg_taken*1.5), 3)
							body.burning = true
					elif GV.Weapon["wand_proj"] == "wand_beam_proj":
						var beam_dmg_timer = Timer.new()
						beam_dmg_timer.name = "beam_dmg_timer"
						beam_dmg_timer.connect("timeout", GV.Enemy["enemy_entites"][i], "_on_beam_dmg_timer_timeout", [GV.Enemy["enemy_entites"][i], dmg_taken])
						GV.Enemy["enemy_entites"][i].add_child(beam_dmg_timer)
						GV.Enemy["enemy_entites"][i].get_node(beam_dmg_timer.name).start()
						body.beam_dmg = true
				else:
					enemy_dmg_taken(i, body)
			if GV.Enemy["enemy_hp"][i] <= 0:
				body.remove_enemy(i)
				body.queue_free()
				GV.Player["player_lvl"] = lvl_progress.value
				break

				GV.Player["player_pwr"] = original_player_pwr

			GV.Player["player_lvl"] = lvl_progress.value

		if GV.Enemy["enemy_tracker"] == 1 and !shop_spawned:
			Globals.spawn_weapon_shop()
			shop_spawned = true

	if "Portal" in body.name:
		var boss_portal_health = 150
		var boss_portal_health_bar = body.get_node("Boss_Portal_HP")
		boss_portal_health_bar.visible = true
		self.queue_free()
		boss_portal_health -= 50
		boss_portal_health_bar.value -= 50
		
		if boss_portal_health_bar.value <= 0:
			body.queue_free()
			GV.Enemy["enemy_hp_value"] += 10
			Globals.num_of_enemies(5)
			GV.Enemy["enemy_entites"].clear()
			GV.Enemy["respawn"] = true
			Globals.spawn_enemy_type()
			GV.Enemy["enemy_res_modifier"] += 2
			GV.Enemy["enemy_dmg_modifier"] += 2
			GV.Boss["boss_res_modifier"] += 2
#			Globals.ilvl += 5
			GV.GUI["GUI"].get_node("number").text = str(GV.Enemy["enemy_tracker"])
			GV.Scene["portal_spawned"] = false

func dmg_calc():
	var enemy_res
	if "Boss" in GV.Scene["current_scene"].name:
		enemy_res = GV.Boss["boss_res"]
	else:
		enemy_res = GV.Enemy["enemy_resistance"]
	
	var dmg = GV.Player["player_pwr"]
	for j in GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("item_stats").get_node("dmg").get_children():
		for k in GV.Enemy["enemy_resistance"]:
			if j.text == k and int(j.get_child(0).text) > 0:
				dmg = float(dmg)/enemy_res.get(k)
				dmg*=15
				dmg = stepify(dmg, 0.01)
	print("dmg ", dmg)
	return dmg
	
func enemy_dmg_taken(pos, enemy):
	var dmg_txt = dmg_floating_txt.instance()
	dmg_txt.position = enemy.position
	GV.Scene["current_scene"].add_child(dmg_txt)
	dmg_txt.get_node("dmg_num_txt").text = str(stepify(dmg_taken, 0.1))
	
	GV.Enemy["enemy_hp"][pos] -= dmg_taken
	enemy_hp_bar.value -= dmg_taken

func _on_Weapon_Timeout_timeout():
	self.queue_free()

func _on_weapon_body_shape_exited(body_id, body, body_shape, local_shape):
	if body != null and "Enemy" in body.name and body.beam_dmg or body != null and "Boss" in body.name and body.beam_dmg:
		body.get_node("beam_dmg_timer").stop()
		body.get_node("beam_dmg_timer").queue_free()
		body.beam_dmg = false
	else:
		return
