#extends KinematicBody2D
#
#var move_speed = 3
#var anim_enemy
#
##var burning = false
##var shocked = false
#
#func _ready():
#	print("bodyRDY")
##	preload("res://Scripts/arrow_ailments.gd")
##	arrow_ailments = preload("res://Scripts/arrow_ailments.gd").new()
#
#func _physics_process(delta):
#
#	if GV.Scenes["current_scene"].name == "Starting_World":
#		attack_movement(self)
#
#func attack_movement(body):
#	anim_enemy = $AnimationPlayer
##	move_speed = 3
#	var dir = body.position.direction_to(GV.Player["player"].position)
#	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
#	anim_enemy.play("attack")
#	if dir.x > 0:
#		$Body.set_flip_h(true)
#	else:
#		$Body.set_flip_h(false)
#
##func unfreeze_timer():
##	yield(get_tree().create_timer(2), "timeout")
##	move_speed = 3
##
##func poison_timer(curr_enemy):
##	var poison_dmg = Globals.player_pwr/5
##	yield(get_tree().create_timer(2), "timeout")
##	GV.Enemy["enemy_hp"][curr_enemy] -= poison_dmg
##	$enemy_hp_bar.value -= poison_dmg
##	if GV.Enemy["enemy_hp"][curr_enemy] <= 0:
##		remove_enemy(curr_enemy)
##	print("poisonStack")
##
##func shock_timer(curr_enemy):
##	shocked = true
##	Globals.player_pwr += 20
##	GV.Enemy["enemy_hp"][curr_enemy] -= Globals.player_pwr
##	$enemy_hp_bar.value -= Globals.player_pwr
##	yield(get_tree().create_timer(5), "timeout")
##	Globals.player_pwr -= 20
##	print("notSHOCKED")
##	shocked = false
##
##func burn_timer(curr_enemy):
##	if burning == false:
##		for i in 5:
##			burning = true
##			yield(get_tree().create_timer(2), "timeout")
##			GV.Enemy["enemy_hp"][curr_enemy] -= 20
##			$enemy_hp_bar.value -= 20
##			if GV.Enemy["enemy_hp"][curr_enemy] <= 0:
##				remove_enemy(curr_enemy)
##		burning = false
##
#func remove_enemy(i):
#	var lvl_progress = Globals.GUI.get_node("lvl_progress")
#
#	GV.Enemy["enemy_id"].remove(i)
#	GV.Enemy["enemy_pos"].remove(i)
#	GV.Enemy["enemy_hp"].remove(i)
#	GV.Enemy["enemies"].remove(i)
#	GV.Enemy["enemy_tracker"] -= 1
#	Globals.drop(self.position)
#	Globals.GUI.get_node("number").text = str(GV.Enemy["enemy_tracker"])
#	if lvl_progress.value == (lvl_progress.max_value-lvl_progress.step):
#		var curr_lvl = int(Globals.GUI.get_node("lvl").text)
#		curr_lvl += 1
#		Globals.GUI.get_node("lvl").text = str(curr_lvl)
#		GV.Player["player_lvl"] = curr_lvl
#		lvl_progress.value = 0
#		GV.Scenes["current_scene"].get_node("GUI").get_node("lvl_up").visible = true
#		var lvlupstats = int(GV.Scenes["current_scene"].get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text) 
#		lvlupstats += 5
#		GV.Scenes["current_scene"].get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text = str(lvlupstats)
#	else:
#		lvl_progress.value += lvl_progress.step
#	self.queue_free()
##
##
