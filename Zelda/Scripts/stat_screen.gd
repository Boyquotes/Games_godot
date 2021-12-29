extends HBoxContainer


func _ready():
	pass

func _on_str_pressed():
	attribute_points($str/Label)
	Globals.player_pwr += 5

func _on_int_pressed():
	attribute_points($int/Label)

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
