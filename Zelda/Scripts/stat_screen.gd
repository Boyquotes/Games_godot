#extends HBoxContainer
##
#func _ready():
#	pass
#
#func _on_str_pressed():
#	attribute_points($str/stren, true, false)
#	attribute_effects("stren", "augment", 1)
#
#func _on_int_pressed():
#	attribute_points($int/intel, true, false)
#	attribute_effects("intel", "augment", 1)
#
#func _on_dex_pressed():
#	attribute_points($dex/dex, true, false)
#	attribute_effects("dex", "augment", 1)
#
#func attribute_points(stat, lvlup_stats, id):
#	var i = int(stat.text)
#	if lvlup_stats:
#		var j = int($points/points_num.text)
#		if j > 0:
#			i += 1
#			j -= 1
#			stat.text = str(i)
#			$points/points_num.text = str(j)
#		if j == 0:
#			$dex.get_parent().visible = false
#	else:
#		if stat.name == "dex" or stat.name == "intel" or stat.name == "stren":
#			for y in Globals.inventory_items:
#				if id == y["id"]:
#					i+= int(y[stat.name])
#					Globals[stat.name] += int(y[stat.name])
#					attribute_effects(stat.name, "augment", int(y[stat.name]))
#			stat.text = str(i)
#		if stat.name == "f":
#			print("statname ", stat.name)
#
#func remove_points(stat, id):
#	var i = int(stat.text)
#	for y in Globals.inventory_items:
#		if id == y["id"]:
#			i-= int(y[stat.name])
#			Globals[stat.name] -= int(y[stat.name])
#			attribute_effects(stat.name, "decrease", int(y[stat.name]))
#	stat.text = str(i)
#
#func attribute_effects(stat, effect, value):
#	if stat == "stren":
#		if effect == "augment":
#			Globals.player_pwr += value
#		else:
#			Globals.player_pwr -= value
#	elif stat == "intel":
#		if effect == "augment":
#			Globals.GUI.get_node("mana_progress").max_value += value
#			Globals.max_mana += value
#			Globals.player.get_node("mana_fill_timer").start()
#		else:
#			Globals.GUI.get_node("mana_progress").max_value -= value
#			Globals.max_mana -= value
#	elif stat == "dex":
#		if effect == "augment":
#			Globals.player.move_speed += (0.2 * value)
#		else: 
#			Globals.player.move_speed -= (0.2 * value)
#
