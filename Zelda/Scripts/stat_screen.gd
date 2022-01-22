extends HBoxContainer

func _ready():
	pass

func _on_str_pressed():
	attribute_points($strength/Label, true, false)
	Globals.strength += 1
	Globals.player_pwr += 5

func _on_int_pressed():
	attribute_points($intelligence/Label, true, false)
	Globals.intelligence += 1
	Globals.GUI.get_node("mana_progress").max_value += 10
	Globals.GUI.get_node("mana_progress").get_node("mana_value").text = str(Globals.GUI.get_node("mana_progress").value)
#	make a scene for the mana_progress node to link theses values

func _on_dex_pressed():
	attribute_points($dexterity/Label, true, false)
	Globals.dexterity += 1
	Globals.player.move_speed += 0.25

func attribute_points(stat, lvlup_stats, id):
	var i = int(stat.text)
	if lvlup_stats:
		var j = int($points/points_num.text)
		if j > 0:
			i += 1
			j -= 1
			stat.text = str(i)
			$points/points_num.text = str(j)
		if j == 0:
			$dexterity.get_parent().visible = false
	else:
		for y in Globals.inventory_items:
			if id == y["id"]:
				i+= int(y[stat.name])
				Globals[stat.name] += int(y[stat.name])
				attribute_effects(stat.name, "augment", int(y[stat.name]))
		stat.text = str(i)
#		augment the Globals variable
		
func remove_points(stat, id):
	var i = int(stat.text)
	for y in Globals.inventory_items:
		if id == y["id"]:
			i-= int(y[stat.name])
			Globals[stat.name] -= int(y[stat.name])
			attribute_effects(stat.name, "decrease", int(y[stat.name]))
	stat.text = str(i)
	
func attribute_effects(stat, effect, value):
	if stat == "stren":
		if effect == "augment":
			Globals.player_pwr += (0.5 * value)
		else:
			Globals.player_pwr += (0.5 * value)
	elif stat == "intel":
		if effect == "augment":
			Globals.GUI.get_node("mana_progress").max_value += value
			Globals.GUI.get_node("mana_progress").get_node("mana_value").text = str(Globals.GUI.get_node("mana_progress").value)
		else:
			Globals.GUI.get_node("mana_progress").max_value -= value
			Globals.GUI.get_node("mana_progress").get_node("mana_value").text = str(Globals.GUI.get_node("mana_progress").value)
	elif stat == "dex":
		if effect == "augment":
			Globals.player.move_speed += (0.025 * value)
		else: 
			Globals.player.move_speed -= (0.025 * value)

