extends HBoxContainer

func _ready():
	pass

func _on_str_pressed():
	attribute_points($str/Label)
	Globals.player_pwr += 5

func _on_int_pressed():
	attribute_points($int/Label)
	Globals.GUI.get_node("mana_progress").max_value += 10
	Globals.GUI.get_node("mana_progress").get_node("mana_value").text = str(Globals.GUI.get_node("mana_progress").value)
#	make a scene for the mana_progress node to link theses values

func _on_dex_pressed():
	attribute_points($dex/Label)
	Globals.player.move_speed += 0.25

func attribute_points(stat):
	var i = int(stat.text)
	var j = int($points/points_num.text)
	if j > 0:
		i += 1
		j -= 1
		stat.text = str(i)
		$points/points_num.text = str(j)
	if j == 0:
		$dex.get_parent().visible = false
