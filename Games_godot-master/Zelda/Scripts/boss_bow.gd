extends "res://Scripts/ailments.gd"

var anim_boss
var dir
var boss_move_speed = 3
var health
var power
var attack_anim = false
var run_anim = false
var boss_move_vec = Vector2()
var dir_to_player

func _ready():
	anim_boss = $AnimationPlayer
	$hp_bar.max_value = Globals.boss_hp_modifier
	$hp_bar.value = Globals.boss_hp_modifier
	$run_cd.wait_time = rnd_run_cd()
	$run_cd.start()
	
	rnd_boss_dir()

func _physics_process(delta):
	
	boss_movement()

func boss_movement():
	dir_to_player = self.position.direction_to(Globals.player.position)
	
	if run_anim == false and attack_anim == false:
		anim_boss.play("bow_idle")
		boss_move_vec = Vector2.ZERO
	elif attack_anim == true:
		anim_boss.play("bow_atk")
	else:
		boss_move_vec = dir.normalized()
		var coll = move_and_collide(boss_move_vec * boss_move_speed)
		if coll:
			if "Level_TileMap" in coll.collider.name:
				rnd_boss_dir()

func rnd_boss_dir():
	var rand = RandomNumberGenerator.new()
	var directions = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
	
	rand.randomize()
	
	dir = directions[rand.randf_range(0, directions.size())]
	
	if dir == Vector2.RIGHT:
		self.get_node("boss_sprite").set_flip_h(false)
	elif dir == Vector2.LEFT:
		self.get_node("boss_sprite").set_flip_h(true)
	else:
		return

func bow_attack_cd(cd, n, mode):
	if mode == "single":
		for i in n:
			yield(get_tree().create_timer(cd), "timeout")
			if attack_anim == false:
				break
			else:
				single_arrow_attack()
	elif mode == "multi":
		for i in n:
			yield(get_tree().create_timer(cd), "timeout")
			if attack_anim == false:
				break
			else:
				multi_arrow_attack()

func single_arrow_attack():
	var arrow = load("res://Scenes/arrow_boss_weapon.tscn").instance()
	arrow.attack_mode = "single"
	Globals.current_scene.add_child(arrow)
	arrow.position = self.position
	
func multi_arrow_attack():
	var rotation = -70
	for arrow in 5:
		arrow = load("res://Scenes/arrow_boss_weapon.tscn").instance()
		arrow.position = self.position
		arrow.rotation_degrees = rotation
		arrow.attack_mode = "multi"
		Globals.current_scene.call_deferred("add_child", arrow)
		if self.get_node("boss_sprite").is_flipped_h() == false:
			arrow.get_node("arrow_sprite").set_flip_h(true)
		rotation += 35

func _on_aggro_range_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Player" in body.name:
		attack_anim = true
		if run_anim == true:
				anim_boss.stop(false)
		if dir_to_player.x > 0:
			self.get_node("boss_sprite").set_flip_h(false)
		else:
			self.get_node("boss_sprite").set_flip_h(true)
		bow_attack_cd(1, 3, "multi")
	else:
		return

func _on_aggro_range_body_shape_exited(body_id, body, body_shape, local_shape):
	if body != null:
		if "Player" in body.name:
			attack_anim = false
			if run_anim == true:
				anim_boss.play("bow_run")
		else:
			return
	else:
		return

func rnd_run_cd():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return rand.randf_range(0, 10)

func _on_run_cd_timeout():
	run_anim = true
	anim_boss.play("bow_run")
	$run_duration.wait_time = rnd_run_cd()
	$run_duration.start()

func _on_run_duration_timeout():
	rnd_boss_dir()
	run_anim = false
