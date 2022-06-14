extends KinematicBody2D

var anim_boss
var move_speed = 1
var health
var power
var attack_anim = false

func _ready():
	anim_boss = $AnimationPlayer
	$boss_hp_bar.max_value = Globals.boss_hp_modifier
	$boss_hp_bar.value = Globals.boss_hp_modifier

func _physics_process(delta):
	boss_movement()

func boss_movement():
	var dir = self.position.direction_to(Globals.player.position)
	move_and_collide(Vector2.move_toward(dir, move_speed))
	
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
		print("playertakesDmg")
		Globals.player.get_node("bleed_timer").start()
		var bleed_dmg_timer = Timer.new()
		bleed_dmg_timer.name = "bleed_dmg_timer"
		bleed_dmg_timer.connect("timeout", Globals.player, "_on_bleed_dmg_timer_timeout")
		Globals.player.add_child(bleed_dmg_timer)
		Globals.player.get_node(bleed_dmg_timer.name).start()
