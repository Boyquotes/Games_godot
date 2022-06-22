extends KinematicBody2D

var anim_boss
var dir
var move_speed = 3
var health
var power
var attack_anim = false
var run_anim = false
var move_vec = Vector2()

func _ready():
	anim_boss = $AnimationPlayer
	$boss_hp_bar.max_value = Globals.boss_hp_modifier
	$boss_hp_bar.value = Globals.boss_hp_modifier
	$run_cd.wait_time = rnd_run_cd()
	$run_cd.start()
	
	rnd_boss_dir()

func _physics_process(delta):
	
	boss_movement()

func boss_movement():
	
	if run_anim == false and attack_anim == false:
		anim_boss.play("bow_idle")
		move_vec = Vector2.ZERO
	elif attack_anim == true:
		anim_boss.play("bow_atk")
	else:
		move_vec = dir.normalized()
		var coll = move_and_collide(move_vec * move_speed)
		if coll:
			if "Level_TileMap" in coll.collider.name:
				print("lvl limit coll")
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

func _on_aggro_range_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Player" in body.name:
		attack_anim = true
	else:
		return

func _on_aggro_range_body_shape_exited(body_id, body, body_shape, local_shape):
	if "Player" in body.name:
		attack_anim = false
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
	run_anim = false
