extends KinematicBody2D

var move_speed = 1
var anim_enemy
var move_vec
var proj_life_time
var snow_attack = false

func _ready():
	anim_enemy = $AnimationPlayer
	proj_life_time = 2
	
	if Globals.current_scene.name == "Desert_World":
		$attack_timeout.set_wait_time(proj_life_time)
		$attack_timeout.start()
		
#	if Globals.current_scene.name == "Fire_World":
#		print("idleAnim")
#		anim_enemy.start()
#		anim_enemy.play("idle")

func _physics_process(delta):

	if Globals.all_attack or snow_attack:
		enemy_attack_move()
	elif Globals.current_scene.name == "Fire_World":
		anim_enemy.play("idle")
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

func enemy_attack_move():
	var dir = self.position.direction_to(Globals.player.position)
	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
	
	anim_enemy.play("attack")
	move_speed = 3
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


