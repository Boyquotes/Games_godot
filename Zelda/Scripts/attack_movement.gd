extends KinematicBody2D


var move_speed
var anim_enemy

func _ready():
	print("ready")

func _physics_process(delta):
	
	attack_movement(self)	
	
func attack_movement(body):
	anim_enemy = $AnimationPlayer
	move_speed = 3
	var dir = body.position.direction_to(Globals.player.position)
	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
	anim_enemy.play("walk_side")
