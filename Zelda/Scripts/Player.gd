extends KinematicBody2D

var level_tilemap
var objects_tilemap
var weapons_tilemap
var anim_player
var move_speed = 5
var player_invuln
var axe_pos
var axe_dir
var attacking = false
var weapon_dir

var weapon = preload("res://Scenes/Weapon.tscn")

func _ready():
	anim_player = $AnimationPlayer
	
	player_invuln = false

	level_tilemap = Globals.current_scene.get_node("Level_TileMap")
	
	if Globals.current_scene.has_node("Weapons_TileMap"):
		weapons_tilemap = Globals.current_scene.get_node("Weapons_TileMap")

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
			
func player_movement():
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
		anim_player.play("Idle")
	if Input.is_action_just_pressed("attack"):
		if Globals.player_weapon == "axe":
			if !attacking:
				axe_pos = - 18
				axe_dir = "y"
			elif attacking and axe_pos == - 18:
				axe_pos = + 15
				axe_dir = "x"
			elif attacking and axe_pos == + 15:
				axe_pos = + 30
				axe_dir = "y"
			elif attacking and axe_pos == + 30:
				axe_pos = -15
				axe_dir = "x"
				attacking = false
			else:
				axe_pos = - 18
				axe_dir = "y"
			weapon_attack(move_vec, axe_pos, axe_dir)
		elif Globals.player_weapon == "staff":
			weapon_attack(move_vec, axe_pos, axe_dir)
#			Globals.current_scene.get_node("weapon").flip_h = true
		else:
			weapon_attack(move_vec, axe_pos, axe_dir)

	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * move_speed)	

func player_collision():
	var coll = move_and_collide(Vector2() * move_speed)

	if coll:
		if coll.collider.name == "Shop_Entrance_Entry":
			Globals.goto_scene("res://Scenes/Levels/Shop.tscn", "null")
		
		if coll.collider.name == "Level_TileMap":
			var level_tile_name = get_tile_name(coll, level_tilemap)[0]
	
			if level_tile_name == "shop_stairs_exit":
				Globals.goto_scene("res://Scenes/Levels/Starting_World.tscn", "null")

		if coll.collider.name == "Weapons_TileMap":
			var weapons_tile_name = get_tile_name(coll, weapons_tilemap)[0]
			var cell = get_tile_name(coll, weapons_tilemap)[1]

			if weapons_tile_name:
				weapon_achievement_anim(weapons_tile_name, coll, cell)
				Globals.inventory_items.push_front(weapons_tile_name)
				Globals.inventory.pickup_item(weapons_tile_name)
	
		if coll.collider.name == "camera_transition":
			var tween = get_node("Camera_Transition")
			self.get_parent().get_node("camera_transition/CollisionShape2D").disabled = true
			
			tween.interpolate_property($Camera2D, "limit_right",
			1124, 2248, 5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			
#			BUG: only triggers once. Maybe leave it this way bc it could be intentional this way (triggering the camera transition is a bit tedious)
			
		if "Enemy" in coll.collider.name and player_invuln == false:
			var hp= int(Globals.GUI.get_node("hp_num").text)
			hp -= 25
			Globals.GUI.get_node("hp_num").text = str(hp)
			Globals.player_hp = hp
#			BUG: hp inc instead dec. could not reproduce why this happened
			self.visible = false
			player_invuln = true
			$invuln_timer.start()
			if Globals.GUI.get_node("hp_num").text == str(0):
				Globals.goto_scene("res://Scenes/game_over_screen.tscn", "null")

func _on_invuln_timer_timeout():
	self.visible = true
	player_invuln = false

func weapon_achievement_anim(weapons_tile_name, coll, cell):
#		if !Globals.player_weapon:
		Globals.player_weapon = weapons_tile_name
		
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
		
func get_tile_name(coll, tilemap):
	var cell = tilemap.world_to_map(coll.position - coll.normal)
	var tile_id = tilemap.get_cellv(cell)
	var tile_name = coll.collider.tile_set.tile_get_name(tile_id)

	return [tile_name, tile_id]

func clear_tile(coll, tile_id):
	return coll.collider.tile_set.remove_tile(tile_id)
	
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
			Globals.current_scene.add_child(weapon)
			weapon.position = self.position
			var wand = load("res://Assets/wand_attack.png")
	
			weapon.get_node("weapon").set_texture(wand)
			var shortest_distance_enemy = Globals.current_scene.get_node("Player_Spawn")
			for i in Globals.enemies:
				var distance_to_player = i.get_global_position().distance_to(self.get_global_position())
				if distance_to_player < shortest_distance_enemy.get_global_position().distance_to(self.get_global_position()):
					shortest_distance_enemy = i
#
			var dir = weapon.position.direction_to(Globals.current_scene.get_node(shortest_distance_enemy.name).position)
#
			weapon.velocity = Vector2.move_toward(dir, weapon.speed)
			
		if Globals.player_weapon == "staff":
			Globals.current_scene.get_node("Player").add_child(weapon)
			var staff = load("res://Assets/staff_attack.png")
			weapon.get_node("weapon").set_texture(staff)
#			weapon.get_node("weapon_coll").rotation_degrees = 45
			weapon.get_node("weapon_coll").scale.y = 3
			weapon.get_node("AnimationPlayer").play("staff_attack")
			
			
			


