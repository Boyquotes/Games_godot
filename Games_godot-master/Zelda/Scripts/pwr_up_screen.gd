extends Container

var pwr_up

func _ready():
	populate_options()

func populate_options():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	pwr_up = PwrUpDB.PWR_UP[str(rand.randi_range(1, PwrUpDB.PWR_UP.size()))]
	
	print(pwr_up)	
#	speed_up
#	pwr_up
#	weapon_pwr_up
#	random item
#	change nxt lvl
#	muns
#	mana reg
#	more_hp
	
func rnd_options():
	pass


func _on_option_one_btn_pressed():
	Globals.entities.clear()
	Globals.ilvl += 10
	Globals.enemy_hp_value += 50
	Globals.num_of_enemies(5)
	Globals.enemy_res_modifier += 5
	Globals.enemy_dmg_modifier += 20
	Globals.respawn = false
	
	Globals.goto_scene("res://Scenes/Levels/" + Globals.next_scene + ".tscn", Globals.current_scene.name)
	


func _on_option_two_btn_pressed():
	pass # Replace with function body.


func _on_option_three_btn_pressed():
	pass # Replace with function body.
