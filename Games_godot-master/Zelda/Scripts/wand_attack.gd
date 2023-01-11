extends Area2D

var move_speed
#var anim_enemy

func _ready():
	print("ready")
#	pass

func _physics_process(delta):
	pass
	
#	attack_movement(self)	
	
#func attack_movement(body):
##	anim_enemy = $AnimationPlayer
#
#
#	move_speed = 1.5
#	var dir = body.position.direction_to(GV.Enemy["enemy_pos"][1])
##	var dir = body.position.direction_to(GF.player.position)
#	position += Vector2.move_toward(dir, move_speed) * move_speed
##	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
##	anim_enemy.play("walk_side")
