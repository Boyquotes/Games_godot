extends Container

var pwr_up_one
var pwr_up_two
var pwr_up_three
var pwr_upDB
var change_next_scene = false

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
	
	for i in self.get_children():
		if "lvl" in i.get_child(0).text:
			print("btn_name ", i.get_child(0).text)
			i.get_child(0).text += "  current: " + Globals.next_scene
	
func _on_option_one_btn_pressed():
	pwr_up_effect(pwr_up_one.name, pwr_up_one.amount)
	goto_next_scene()

func _on_option_two_btn_pressed():
	pwr_up_effect(pwr_up_two.name, pwr_up_two.amount)
	goto_next_scene()

func _on_option_three_btn_pressed():
	pwr_up_effect(pwr_up_three.name, pwr_up_three.amount)
	goto_next_scene()
	
func pwr_up_effect(name, amount):
	if "speed" in name:
		Globals.player_move_speed += amount
	elif "hp" in name:
		Globals.player_hp += amount
	elif "coins" in name:
		Globals.coins += amount
	elif "mana" in name:
		Globals.max_mana += amount
	elif "lvl" in name:
		change_next_scene = true
	elif "armor" in name:
		Globals.drop_body_armour(self.rect_position, Globals.ilvl)
		Globals.inventory_items.push_front(Globals.dropped_items[0])
		Globals.dropped_items.remove(0)
	elif "weapon" in name:
		Globals.drop_weapon(self.rect_position, Globals.ilvl)
		Globals.inventory_items.push_front(Globals.dropped_items[0])
		Globals.dropped_items.remove(0)
				
func goto_next_scene():
	print("gotoNext")
	Globals.entities.clear()
	Globals.ilvl += 10
	Globals.enemy_hp_value += 50
	Globals.num_of_enemies(5)
	Globals.enemy_res_modifier += 5
	Globals.enemy_dmg_modifier += 20
	Globals.respawn = false
	if change_next_scene:
		print("randomScene")
		Globals.goto_scene("res://Scenes/Levels/" + Globals.random_scene() + ".tscn", Globals.current_scene.name)
		change_next_scene = false
	else:
		Globals.goto_scene("res://Scenes/Levels/" + Globals.next_scene + ".tscn", Globals.current_scene.name)
		
