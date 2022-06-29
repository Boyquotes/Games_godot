extends KinematicBody2D

onready var anim = $AnimationPlayer
var attack = false
var move_vec = Vector2()
var move_speed = 3
onready var dir = Vector2.RIGHT


func _ready():
	pass
	
#	rnd_boss_dir()
	
func _physics_process(delta):
	if attack == false:
		anim.play("slime_idle")

#
	if dir == Vector2.RIGHT:
		self.get_node("boss_sprite").set_flip_h(false)
	elif dir == Vector2.LEFT:
		self.get_node("boss_sprite").set_flip_h(true)
#	else:
##		return

#func rnd_boss_dir():
#	var rand = RandomNumberGenerator.new()
#	var directions = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
#
#	rand.randomize()
#
##	dir = directions[rand.randf_range(0, directions.size())]
#	dir = Vector2.RIGHT

func jump_attack():

	var pos = self.position
	
	print("currentPos ", pos)
	
	if dir == Vector2.RIGHT:
		anim.get_animation("slime_attack").track_set_key_value(1, 0, Vector2(pos.x+30, pos.y-10))
		anim.get_animation("slime_attack").track_set_key_value(1, 1, Vector2(pos.x+60, pos.y-20))
		anim.get_animation("slime_attack").track_set_key_value(1, 2, Vector2(pos.x+90, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 3, Vector2(pos.x+120, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 4, Vector2(pos.x+150, pos.y+30))
		anim.get_animation("slime_attack").track_set_key_value(1, 5, Vector2(pos.x+180, pos.y+20))
		anim.get_animation("slime_attack").track_set_key_value(1, 6, Vector2(pos.x+210, pos.y+10))
	else:
		anim.get_animation("slime_attack").track_set_key_value(1, 0, Vector2(pos.x-30, pos.y-10))
		anim.get_animation("slime_attack").track_set_key_value(1, 1, Vector2(pos.x-60, pos.y-20))
		anim.get_animation("slime_attack").track_set_key_value(1, 2, Vector2(pos.x-90, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 3, Vector2(pos.x-120, pos.y-30))
		anim.get_animation("slime_attack").track_set_key_value(1, 4, Vector2(pos.x-150, pos.y+30))
		anim.get_animation("slime_attack").track_set_key_value(1, 5, Vector2(pos.x-180, pos.y+20))
		anim.get_animation("slime_attack").track_set_key_value(1, 6, Vector2(pos.x-210, pos.y+10))

	anim.stop(true)
	anim.queue("slime_start_jump")
	anim.queue("slime_attack")
	anim.queue("slime_stop_jump")

func _on_Aggro_range_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Player" in body.name:
		print("bodyEntered")
		jump_attack()
		attack = true

func _on_Aggro_range_body_shape_exited(body_id, body, body_shape, local_shape):
	if "Player" in body.name:
		attack = false


func _on_coll_area_body_entered(body):
	if "Level_TileMap" in body.name:
		print("coll")
		if attack:
			if dir == Vector2.RIGHT:
				dir = Vector2.LEFT
			else:
				dir = Vector2.RIGHT
