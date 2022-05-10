extends "res://Scripts/Enemy_behaviour.gd"

var body = self
var burning = false
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
	
func burn_timer(curr_enemy, dmg_value):
#	print("dmgVAL ", dmg_value)
	if burning == false:
		for i in 5:
			burning = true
			if Globals.enemy_hp[curr_enemy] > 0:
				yield(get_tree().create_timer(2), "timeout")
				Globals.enemy_hp[curr_enemy] -= dmg_value
				$enemy_hp_bar.value -= dmg_value
			else:
				remove_enemy(curr_enemy)
				return
			burning = false
