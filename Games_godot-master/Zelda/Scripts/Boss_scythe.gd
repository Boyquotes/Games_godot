extends "res://Scripts/ailments.gd"

var anim_boss
var dir
var boss_move_speed = 1
var health
var power
var attack_anim = false

func _ready():
	anim_boss = $AnimationPlayer
	$hp_bar.max_value = Globals.boss_hp_modifier
	$hp_bar.value = Globals.boss_hp_modifier
	$scythe_throw_timer.start()

func _physics_process(delta):
	boss_movement()

func boss_movement():
	dir = self.position.direction_to(Globals.player.position)
	move_and_collide(Vector2.move_toward(dir, boss_move_speed))
	
	if dir.x > 0:
		self.get_node("boss_sprite").set_flip_h(false)
	else:
		self.get_node("boss_sprite").set_flip_h(true)
		
	if attack_anim == false:
		anim_boss.play("idle")

func _on_attack_zone_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == "Player":
		anim_boss.play("attack_scythe")
		attack_anim = true

func _on_attack_zone_body_shape_exited(body_id, body, body_shape, local_shape):
	if body.name == "Player":
		attack_anim = false

func _on_attack_dmg_zone_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == "Player":
		body.bleed_damage(2)

func _on_scythe_throw_timer_timeout():
	var scythe = load("res://Scenes/Scythe_boss_weapon.tscn").instance()
	Globals.current_scene.get_node("Boss_scythe").add_child(scythe)
	scythe.position = dir
	scythe.get_node("AnimationPlayer").play("scythe_throw")
	
	
