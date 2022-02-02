extends StaticBody2D

func _ready():
	pass
	
func _process(delta):
	pass

func _on_drop_mouse_entered():
	if Input.is_action_pressed("showTT"):
		if !$stats_tt.visible:
			$stats_tt.rect_position = self.position
			$stats_tt.show()
#		else:
#			$stats_tt.hide()
#	$stats_tt.rect_position = self.position
#	$stats_tt.show()

func _on_drop_mouse_exited():
	$stats_tt.hide()
