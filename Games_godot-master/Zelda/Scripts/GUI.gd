extends CanvasLayer

func _ready():
	pass

func _on_str_pressed():
	attribute_points($stat_container/stat_screen/str/stren, true, false)
	attribute_effects("stren", "augment", 1)
	Globals.stren += 1

func _on_int_pressed():
	attribute_points($stat_container/stat_screen/int/intel, true, false)
	attribute_effects("intel", "augment", 1)
	Globals.intel += 1

func _on_dex_pressed():
	attribute_points($stat_container/stat_screen/dex/dex, true, false)
	attribute_effects("dex", "augment", 1)
	Globals.dex += 1

func attribute_points(stat, lvlup_stats, id):
#	print("addPoints ", Globals.inventory_items[id].name, " ", stat.name)
	var i = int(stat.text)
	if lvlup_stats:
		var j = int($points_container/points/points_num.text)
		if j > 0:
			i += 1
			j -= 1
			stat.text = str(i)
			$points_container/points/points_num.text = str(j)
		if j == 0:
			$stat_container.visible = false
			$points_container.visible = false
	else:
		if stat.name == "dex" or stat.name == "intel" or stat.name == "stren":
			for y in Globals.inventory_items:
				if id == y["id"]:
					i+= int(y[stat.name])
					Globals[stat.name] += int(y[stat.name])
					attribute_effects(stat.name, "augment", int(y[stat.name]))
			stat.text = str(i)
		if stat.name == "fire" or stat.name == "cold" or stat.name == "lightning" or stat.name == "physical" or stat.name == "poison":
			for y in Globals.inventory_items:
				if id == y["id"]:
					i += int(y[stat.name])
					Globals.player_resistance[stat.name] += int(y[stat.name])
					if Globals.player_resistance[stat.name] >= 60:
						Globals.player_resistance[stat.name] = 60
			stat.text = str(Globals.player_resistance[stat.name])
		if stat.name == "power":
			for y in Globals.inventory_items:
				if id == y["id"]:
					i += int(y[stat.name])
					Globals.player_pwr += int(y[stat.name])
					Globals.player_dmg_types[y["dmg_type"]] += y[stat.name]
					Globals.GUI.get_node("stat_container").get_node("dmg").get_node(y["dmg_type"]).get_child(0).text = str(Globals.player_dmg_types[y["dmg_type"]])
			stat.text = str(i)
		if stat.name == "special":
			print("activate_special")
		
func remove_points(stat, id):
#	print("removePoints ", Globals.inventory_items[id].name, " ", stat.name)
	var i = int(stat.text)
	if stat.name == "dex" or stat.name == "intel" or stat.name == "stren":
		for y in Globals.inventory_items:
			if id == y["id"]:
				i-= int(y[stat.name])
				Globals[stat.name] -= int(y[stat.name])
				attribute_effects(stat.name, "decrease", int(y[stat.name]))
		stat.text = str(i)
	if stat.name == "fire" or stat.name == "cold" or stat.name == "lightning" or stat.name == "physical" or stat.name == "poison":
		for y in Globals.inventory_items:
			if id == y["id"]:
				i -= int(y[stat.name])
				Globals.player_resistance[stat.name] -= int(y[stat.name])
				if Globals.player_resistance[stat.name] >= 60:
					Globals.player_resistance[stat.name] = 60
		stat.text = str(Globals.player_resistance[stat.name])
	if stat.name == "power":
		for y in Globals.inventory_items:
			if id == y["id"]:
				i -= int(y[stat.name])
				Globals.player_pwr -= int(y[stat.name])
				Globals.player_dmg_types[y["dmg_type"]] -= y[stat.name]
				Globals.GUI.get_node("stat_container").get_node("dmg").get_node(y["dmg_type"]).get_child(0).text = str(Globals.player_dmg_types[y["dmg_type"]])
		stat.text = str(i)
			
func attribute_effects(stat, effect, value):
	if stat == "stren":
		if effect == "augment":
			Globals.player_pwr += value
			Globals.GUI.get_node("stat_container").get_node("stat_screen").get_node("power").get_node("power").text = str(Globals.player_pwr)
		else:
			Globals.player_pwr -= value
			Globals.GUI.get_node("stat_container").get_node("stat_screen").get_node("power").get_node("power").text = str(Globals.player_pwr)
	elif stat == "intel":
		if effect == "augment":
			Globals.GUI.get_node("mana_progress").max_value += value
			Globals.max_mana += value
			Globals.player.get_node("mana_fill_timer").start()
		else:
			Globals.GUI.get_node("mana_progress").max_value -= value
			Globals.max_mana -= value
			Globals.GUI.get_node("mana_progress").get_node("mana_value").text = str(Globals.max_mana)
	elif stat == "dex":
		if effect == "augment":
			Globals.player_move_speed += (0.02 * value)
			print("augmentSpeed ", Globals.player_move_speed)
		else: 
			Globals.player_move_speed -= (0.02 * value)
			print("decSpeed ", Globals.player_move_speed)
			
func buff_effects(buff, effect):
	if effect == "activate":
		if "fire_proj" in buff:
			Globals.wand_proj = "fire_one"
		elif "lazor" in buff:
			Globals.wand_proj = "wand_beam_proj"
			return
	else:
		Globals.wand_proj = null

