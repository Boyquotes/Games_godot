extends KinematicBody2D

var move_speed
var anim_enemy
var move_vec
#var coll

func _ready():
	anim_enemy = $AnimationPlayer

func _physics_process(delta):

#	enemy_movement()
#	
	if Globals.all_attack:
		enemy_attack_move()
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
		if "Enemy" in coll.collider.name or coll.collider.name == "Level_TileMap" or coll.collider.name == "Shop_Entrance_Entry":
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
	anim_enemy.play("walk_side")
	move_speed = 3

#			print("attack")
	
#	if coll:
#		print(coll.collider.name)
	
#	======alternative movement solution==========
	#	var prev_pos = follow_path.get_global_position()
#	follow_path.set_offset(follow_path.get_offset() + move_speed * delta)
#	var pos = follow_path.get_global_position()
#	move_dir = (pos.angle_to_point(prev_pos) / 3.14) * 180
#	anim_enemy.play("enemy_goober_walk")
