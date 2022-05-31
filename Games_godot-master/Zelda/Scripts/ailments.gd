extends "res://Scripts/Enemy_behaviour.gd"

var body = self
var burningx
var shocked = false

func _ready():
	pass

func unfreeze_timer(curr_enemy):
	yield(get_tree().create_timer(2), "timeout")
	curr_enemy.move_speed = 3

func poison_timer(curr_enemy, dmg_value):
#	print("dmgVAL ", dmg_value)
	var poison_dmg = dmg_value
	yield(get_tree().create_timer(2), "timeout")
	Globals.enemy_hp[curr_enemy] -= poison_dmg
	$enemy_hp_bar.value -= poison_dmg
	if Globals.enemy_hp[curr_enemy] <= 0:
		remove_enemy(curr_enemy)
	
func shock_timer(curr_enemy, dmg_value):
	shocked = true
	dmg_value += 20
	Globals.enemy_hp[curr_enemy] -= dmg_value
	$enemy_hp_bar.value -= dmg_value
	yield(get_tree().create_timer(5), "timeout")
#	Globals.player_pwr -= 20
	shocked = false
	
func burn_timer(curr_enemy, dmg_value, ticks):
#	print("currEnemy ", curr_enemy)
#	for i in Globals.enemy_hp.size():
#		if Globals.enemy_hp[i] < Globals.enemy_hp_value and curr_enemy == Globals.enemy_hp.size()-1 and Globals.enemy_hp.size() > 1:
#			print("checkEnemies")
#			if Globals.enemy_hp[i] < (dmg_value*ticks) and Globals.enemies[i].burning == true:
#				curr_enemy -= 1 
#				print("adjustPos")
#	print("arraySize ", Globals.enemy_hp.size())
##	print("currentEnemy ", curr_enemy)
#	if Globals.enemy_hp[curr_enemy] <= 0:
#				remove_enemy(curr_enemy)
#				burning = false
#				return
	for i in ticks:
		yield(get_tree().create_timer(2), "timeout")
		while curr_enemy == Globals.enemy_hp.size():
#			print("adjustPos")
			curr_enemy-=1
		Globals.enemy_hp[curr_enemy] -= dmg_value
		$enemy_hp_bar.value -= dmg_value
#		print("currentEnemy ", curr_enemy)
#		print("arraySize ", Globals.enemy_hp.size())
		if i == ticks-1:
			burning = false
		if Globals.enemy_hp[curr_enemy] <= 0:
			remove_enemy(curr_enemy)
			burning = false
			break
			return
				


