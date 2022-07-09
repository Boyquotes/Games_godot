extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var attack = false
var move_vec = Vector2()
var move_speed = 3
onready var dir = Vector2.RIGHT


func _ready():
	$boss_hp_bar.max_value = Globals.boss_hp_modifier
	$boss_hp_bar.value = Globals.boss_hp_modifier

func _physics_process(delta):
	if attack == false:
		anim.play("slime_idle")

	if dir == Vector2.RIGHT:
		self.get_node("boss_sprite").set_flip_h(false)
	elif dir == Vector2.LEFT:
		self.get_node("boss_sprite").set_flip_h(true)
	else:
		return

func jump_attack():

	var pos = self.position
	var set_landing = rnd_height(pos)

	if dir == Vector2.RIGHT:
		anim.get_animation("slime_attack").track_set_key_value(1, 0, Vector2(pos.x+30, pos.y-10))
		anim.get_animation("slime_attack").track_set_key_value(1, 1, Vector2(pos.x+60, pos.y-20))
		anim.get_animation("slime_attack").track_set_key_value(1, 2, Vector2(pos.x+90, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 3, Vector2(pos.x+120, pos.y-40))
		anim.get_animation("slime_attack").track_set_key_value(1, 4, Vector2(pos.x+150, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 5, Vector2(pos.x+180, pos.y-20))
		anim.get_animation("slime_attack").track_set_key_value(1, 6, set_landing)
	else:
		anim.get_animation("slime_attack").track_set_key_value(1, 0, Vector2(pos.x-30, pos.y-10))
		anim.get_animation("slime_attack").track_set_key_value(1, 1, Vector2(pos.x-60, pos.y-20))
		anim.get_animation("slime_attack").track_set_key_value(1, 2, Vector2(pos.x-90, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 3, Vector2(pos.x-120, pos.y-40))
		anim.get_animation("slime_attack").track_set_key_value(1, 4, Vector2(pos.x-150, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 5, Vector2(pos.x-180, pos.y-20))
		anim.get_animation("slime_attack").track_set_key_value(1, 6, set_landing)

	anim.queue("slime_start_jump")
	anim.queue("slime_attack")
	anim.queue("slime_stop_jump")

func _on_Aggro_range_body_shape_entered(body_id, body, body_shape, local_shape):
	var jumps = rnd_jumps()
	
	if $Aggro_range/aggro_coll.disabled == false:
		if "Player" in body.name:
			anim.stop(true)
			attack = true
			jump_sequence(jumps)
	else:
		return

func rnd_jumps():
	var rand = RandomNumberGenerator.new()
	rand.randomize()

	return rand.randf_range(2, 5)

func jump_sequence(n):
	$Aggro_range/aggro_coll.set_deferred("disabled", true)
	jump_attack()
	for i in n:
		yield(get_tree().create_timer(3), "timeout")
		jump_attack()

	yield(get_tree().create_timer(3), "timeout")
	$Aggro_range/aggro_coll.disabled = false
	attack = false

func rnd_height(pos):
	var rand = RandomNumberGenerator.new()
	var landing_height

	if dir == Vector2.RIGHT:
		landing_height = [Vector2(pos.x+210, pos.y), Vector2(pos.x+210, pos.y-10), Vector2(pos.x+210, pos.y+10), Vector2(pos.x+210, pos.y+20), Vector2(pos.x+210, pos.y-20)]
	else:
		landing_height = [Vector2(pos.x-210, pos.y), Vector2(pos.x-210, pos.y-10), Vector2(pos.x-210, pos.y+10), Vector2(pos.x-210, pos.y+20), Vector2(pos.x-210, pos.y-20)]

	rand.randomize()

	return landing_height[rand.randf_range(0, landing_height.size())]

func _on_coll_area_body_entered(body):
	var jumps = rnd_jumps()
	if "Level_TileMap" in body.name:
		print("slimeCOLL")
		anim.stop(true)
		if dir == Vector2.RIGHT:
			dir = Vector2.LEFT
		else:
			dir = Vector2.RIGHT
		call_deferred("jump_sequence", jumps)
	if "Player" in body.name:
		body.loose_hp(Globals.enemy_dmg_modifier*2)
		
