extends "res://Scripts/Enemy_mov.gd"

var body = self
var burning = false
var shocked = false

func _ready():
	pass
	
func test():
	print("test")
	
func unfreeze_timer(curr_enemy):
	yield(get_tree().create_timer(2), "timeout")
	curr_enemy.move_speed = 3

func poison_timer(curr_enemy):
	var poison_dmg = Globals.player_pwr/5
	yield(get_tree().create_timer(2), "timeout")
	Globals.enemy_hp[curr_enemy] -= poison_dmg
	$enemy_hp_bar.value -= poison_dmg
	if Globals.enemy_hp[curr_enemy] <= 0:
		remove_enemy(curr_enemy)
	
func shock_timer(curr_enemy):
	shocked = true
	Globals.player_pwr += 20
	Globals.enemy_hp[curr_enemy] -= Globals.player_pwr
	$enemy_hp_bar.value -= Globals.player_pwr
	yield(get_tree().create_timer(5), "timeout")
	Globals.player_pwr -= 20
	shocked = false
	
func burn_timer(curr_enemy):
	if burning == false:
		for i in 5:
			burning = true
			yield(get_tree().create_timer(2), "timeout")
			Globals.enemy_hp[curr_enemy] -= 20
			$enemy_hp_bar.value -= 20
			if Globals.enemy_hp[curr_enemy] <= 0:
				remove_enemy(curr_enemy)
		burning = false
		
#func remove_enemy(i):
#	var lvl_progress = Globals.GUI.get_node("lvl_progress")
#	print("removeENEMy")
#	Globals.enemy_id.remove(i)
#	Globals.enemy_pos.remove(i)
#	Globals.enemy_hp.remove(i)
#	Globals.enemies.remove(i)
#	Globals.enemy_tracker -= 1
#	Globals.drop(self.position)
#	Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)
#	if lvl_progress.value == (lvl_progress.max_value-lvl_progress.step):
#		var curr_lvl = int(Globals.GUI.get_node("lvl").text)
#		curr_lvl += 1
#		Globals.GUI.get_node("lvl").text = str(curr_lvl)
#		Globals.player_lvl = curr_lvl
#		lvl_progress.value = 0
#		Globals.current_scene.get_node("GUI").get_node("lvl_up").visible = true
#		var lvlupstats = int(Globals.current_scene.get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text) 
#		lvlupstats += 5
#		Globals.current_scene.get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text = str(lvlupstats)
#	else:
#		lvl_progress.value += lvl_progress.step
#	self.queue_free()