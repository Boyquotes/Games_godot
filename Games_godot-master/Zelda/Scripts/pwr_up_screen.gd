extends Container

var pwr_up_one
var pwr_up_two
var pwr_up_three
var pwr_upDB

func _ready():
	
	populate_options()

func populate_options():
	pwr_upDB = PwrUpDb.pwr_upDB
	var rand = RandomNumberGenerator.new()
	var pwr_up_arr = []
	rand.randomize()
	
	for i in pwr_upDB:
		pwr_up_arr.push_back(i)
	
	pwr_up_one = pwr_upDB[str(rand.randi_range(0, pwr_up_arr.size()-1))]
	pwr_up_two = pwr_upDB[str(rand.randi_range(0, pwr_up_arr.size()-1))]
	while pwr_up_one.name == pwr_up_two.name:
		pwr_up_two = pwr_upDB[str(rand.randi_range(0, pwr_up_arr.size()-1))]
		if pwr_up_one.name != pwr_up_two.name:
			break
	pwr_up_three = pwr_upDB[str(rand.randi_range(0, pwr_up_arr.size()-1))]
	while pwr_up_two.name == pwr_up_three.name or pwr_up_one.name == pwr_up_three.name:
		pwr_up_three = pwr_upDB[str(rand.randi_range(0, pwr_up_arr.size()-1))]
		if pwr_up_two.name != pwr_up_three.name and pwr_up_one.name != pwr_up_three.name:
			break
	
	$option_one_btn/option_one_txt.text = pwr_up_one.name
	$option_two_btn/option_two_txt.text = pwr_up_two.name
	$option_three_btn/option_three_txt.text = pwr_up_three.name
	
func rnd_options():
	pass

func _on_option_one_btn_pressed():
	pwr_up_effect(pwr_up_one.type, pwr_up_one.amount)	
	goto_next_scene()

func _on_option_two_btn_pressed():
	pwr_up_effect(pwr_up_two.type, pwr_up_two.amount)
	goto_next_scene()

func _on_option_three_btn_pressed():
	pwr_up_effect(pwr_up_three.type, pwr_up_three.amount)	
	goto_next_scene()
	
func pwr_up_effect(type, amount):
	if "speed" in type:
		Globals.player_move_speed += amount
	elif "hp" in type:
		Globals.player_hp += amount
	elif "coins" in type:
		Globals.coins += amount
	elif "mana" in type:
		Globals.max_mana += amount
	
func goto_next_scene():
	Globals.entities.clear()
	Globals.ilvl += 10
	Globals.enemy_hp_value += 50
	Globals.num_of_enemies(5)
	Globals.enemy_res_modifier += 5
	Globals.enemy_dmg_modifier += 20
	Globals.respawn = false
	Globals.goto_scene("res://Scenes/Levels/" + Globals.next_scene + ".tscn", Globals.current_scene.name)
