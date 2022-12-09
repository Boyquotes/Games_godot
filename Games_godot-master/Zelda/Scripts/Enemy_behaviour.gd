extends KinematicBody2D

var move_speed
var anim_enemy
var move_vec
var proj_life_time
var snow_attack = false
var enemy_attack = false
var burning
var beam_dmg

func _ready():
	anim_enemy = $AnimationPlayer
	proj_life_time = 2
	
	if GV.Scenes["current_scene"].name == "Desert_World":
		$attack_timeout.set_wait_time(proj_life_time)
		$attack_timeout.start()

func _physics_process(delta):

	if Globals.all_attack or snow_attack or enemy_attack:
		enemy_attack_move()
	elif GV.Scenes["current_scene"].name == "Fire_World":
		anim_enemy.play("idle")
	elif "Boss" in GV.Scenes["current_scene"].name:
		pass
	else:
		enemy_movement()

func enemy_movement():
	move_speed = 1
	if move_vec == Vector2.DOWN:
		anim_enemy.play("walk_down")
	if move_vec == Vector2.UP:
		anim_enemy.play("walk_up")
	if move_vec == Vector2.RIGHT:
		$Body.set_flip_h(true)
		anim_enemy.play("walk_side")
	if move_vec == Vector2.LEFT:
		$Body.set_flip_h(false)
		anim_enemy.play("walk_side")

	move_vec = move_vec.normalized()
	
	var coll = move_and_collide(move_vec * move_speed)

	if coll:
		if "Enemy" in coll.collider.name or coll.collider.name == "Level_TileMap" or coll.collider.name == "Shop_Entrance_Entry" or coll.collider.name == "Objects_TileMap":
			if move_vec == Vector2.DOWN:
				move_vec = Vector2.UP
			elif move_vec == Vector2.UP:
				move_vec = Vector2.DOWN
			elif move_vec == Vector2.LEFT:
				move_vec = Vector2.RIGHT
			elif move_vec == Vector2.RIGHT:
				move_vec = Vector2.LEFT
				
func _on_Area2D_area_entered(area):
	if "web" in area.name:
		move_speed = 0.5

func _on_Area2D_area_exited(area):
	if "web" in area.name:
		move_speed = 1

func enemy_attack_move():
	move_speed = 1
	var dir = self.position.direction_to(GV.Player["player"].position)
	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
	
	anim_enemy.play("attack")
#	move_speed += 3
	if dir.x > 0:
		$Body.set_flip_h(true)
	else:
		$Body.set_flip_h(false)
		
func fire_poison_proj():
	var proj = load("res://Scenes/snake_proj.tscn").instance()
	self.get_parent().call_deferred("add_child", proj)
	proj.position = self.position
	proj.get_node("proj_pos").position = self.position

func _on_attack_timeout_timeout():
	fire_poison_proj()
	
func _on_detection_layer_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == "Player":
		$AnimationPlayer.play("attack")
		snow_attack = true

func fire_thorn_proj(dir):
	var proj = load("res://Scenes/thorn_proj.tscn").instance()
	self.get_parent().call_deferred("add_child", proj)
	proj.position = self.position
	proj.get_node("proj_pos").position = self.position
	
	proj.rotation_degrees = dir
	proj.velocity = Vector2(-0.5, 0.3)
	
	if dir == 0:
		proj.velocity = Vector2(-0.5, -0.3)
	elif dir == 90:
		proj.velocity = Vector2(0.5, -0.3)
	elif dir == 180:
		proj.velocity = Vector2(0.5, 0.3)
	elif dir == 270:
		proj.velocity = Vector2(-0.5, 0.3)

func _on_detection_layer_thorn_body_entered(body):
	if body.name == "Player":
		$jungle_attack_timeout.set_wait_time(1)
		$jungle_attack_timeout.start()

func _on_detection_layer_thorn_body_exited(body):
	if body.name == "Player":
		$jungle_attack_timeout.stop()

func _on_jungle_attack_timeout_timeout():
	var dir = 0
	for i in 4:
		fire_thorn_proj(dir)
		dir += 90
		
func _on_beam_dmg_timer_timeout(enemy, dmg_taken):
#	print("enemy ", enemy, " takes ", dmg_taken)
	Globals.enemy_hp[Globals.entities.find(enemy)] -= dmg_taken
	self.get_node("hp_bar").value -= dmg_taken
	if Globals.enemy_hp[Globals.entities.find(enemy)] <= 0:
		self.remove_enemy(Globals.entities.find(enemy))

func remove_enemy(i):
	var lvl_progress = Globals.GUI.get_node("lvl_progress")
	if "Boss" in Globals.entities[i].name:
		Globals.drop(self.position, 1, 1)
	else:
		Globals.drop(self.position, null, null)
	Globals.enemies[i].queue_free()
	Globals.enemy_id.remove(i)
	Globals.enemy_hp.remove(i)
	Globals.enemy_pos.remove(i)
	Globals.enemies.remove(i)
	Globals.entities.remove(i)
	Globals.enemy_tracker -= 1
	Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)
	if lvl_progress.value == (lvl_progress.max_value-lvl_progress.step):
		var curr_lvl = int(Globals.GUI.get_node("lvl").text)
		curr_lvl += 1
		Globals.GUI.get_node("lvl").text = str(curr_lvl)
		Globals.player_lvl = curr_lvl
		lvl_progress.value = 0
		GV.Scenes["current_scene"].get_node("GUI").get_node("lvl_up").visible = true
		var lvlupstats = int(GV.Scenes["current_scene"].get_node("GUI").get_node("points_container").get_node("points").get_node("points_num").text) 
		lvlupstats += 5
		GV.Scenes["current_scene"].get_node("GUI").get_node("points_container").get_node("points").get_node("points_num").text = str(lvlupstats)
	else:
		lvl_progress.value += lvl_progress.step
	if Globals.enemy_tracker == 0:
			print("spawn boss portal")
			Globals.spawn_boss_portal()
			return





