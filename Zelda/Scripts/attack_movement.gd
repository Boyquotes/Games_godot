extends KinematicBody2D

var move_speed = 3
var anim_enemy

func _ready():
	pass

func _physics_process(delta):
	
	if Globals.current_scene.name == "Starting_World":
		attack_movement(self)
	
func attack_movement(body):
	anim_enemy = $AnimationPlayer
#	move_speed = 3
	var dir = body.position.direction_to(Globals.player.position)
	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
	anim_enemy.play("attack")
	if dir.x > 0:
		$Body.set_flip_h(true)
	else:
		$Body.set_flip_h(false)
