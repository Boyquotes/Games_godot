extends KinematicBody2D

var anim_boss

func _ready():
	anim_boss = $AnimationPlayer

func _physics_process(delta):
	anim_boss.play("idle")
