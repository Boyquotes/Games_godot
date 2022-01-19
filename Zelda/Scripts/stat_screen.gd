extends HBoxContainer

func _ready():
	pass

func _on_str_pressed():
	attribute_points($strength/Label, true)
	Globals.strength += 1
	Globals.player_pwr += 5

func _on_int_pressed():
	attribute_points($intelligence/Label, true)
	Globals.intelligence += 1
	Globals.GUI.get_node("mana_progress").max_value += 10
	Globals.GUI.get_node("mana_progress").get_node("mana_value").text = str(Globals.GUI.get_node("mana_progress").value)
#	make a scene for the mana_progress node to link theses values

func _on_dex_pressed():
	attribute_points($dexterity/Label, true)
	Globals.dexterity += 1
	Globals.player.move_speed += 0.25

func attribute_points(stat, lvlup_stats):
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
		i+= int(Globals.inventory_items[0][stat.name])
#		int(Globals.current_scene.get_node("item").get_node("stats_tt").get_node("stats").get_node(stat.name).get_node("value").text)
		stat.text = str(i)
#		augment the Globals variable
		
func remove_points(stat):
	var i = int(stat.text)
#	i-= int(Globals.current_scene.get_node("item").get_node("stats_tt").get_node("stats").get_node(stat.name).get_node("value").text)
	i-= int(Globals.inventory_items[0][stat.name])
#	print(Globals.inventory_items[0])
	stat.text = str(i)
#	reduce the Globals variable

