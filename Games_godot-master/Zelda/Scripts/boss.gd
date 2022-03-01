extends KinematicBody2D

var anim_boss
var move_speed = 1

func _ready():
	anim_boss = $AnimationPlayer

func _physics_process(delta):
	anim_boss.play("idle")
	boss_movement()

func boss_movement():
	var dir = self.position.direction_to(Globals.player.position)
	move_and_collide(Vector2.move_toward(dir, move_speed))
