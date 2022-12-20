extends "res://Scripts/Enemy_behaviour.gd"

var body = self
var burningx
var shocked = false

func _ready():
	pass

func unfreeze_timer(curr_enemy):
	print("frozenEnemy ", curr_enemy)
	yield(get_tree().create_timer(2), "timeout")
	self.move_speed = 3

func poison_timer(curr_enemy, dmg_value):
#	print("dmgVAL ", dmg_value)
	var poison_dmg = dmg_value
	yield(get_tree().create_timer(2), "timeout")
	Globals.enemy_hp[curr_enemy] -= poison_dmg
	$hp_bar.value -= poison_dmg
	if Globals.enemy_hp[curr_enemy] <= 0:
		remove_enemy(curr_enemy)

func shock_timer(curr_enemy, dmg_value):
	shocked = true
	dmg_value += 20
	Globals.enemy_hp[curr_enemy] -= dmg_value
	$hp_bar.value -= dmg_value
	yield(get_tree().create_timer(5), "timeout")
#	GV.Player["player_pwr"] -= 20
	shocked = false

func burn_timer(curr_enemy, dmg_value, ticks):
	for i in ticks:
		yield(get_tree().create_timer(2), "timeout")
		while curr_enemy == Globals.enemy_hp.size():
			curr_enemy-=1
			print("adjust ", curr_enemy, Globals.enemy_hp.size())
		Globals.enemy_hp[curr_enemy] -= dmg_value
		$hp_bar.value -= dmg_value
		if i == ticks-1:
			burning = false
		if Globals.enemy_hp[curr_enemy] <= 0:
			remove_enemy(curr_enemy)
			burning = false
			break
			return
