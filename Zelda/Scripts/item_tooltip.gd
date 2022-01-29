extends StaticBody2D

func _ready():
	pass

func _on_drop_mouse_entered():
	$stats_tt.rect_position = self.position
	$stats_tt.show()
		
func _on_drop_mouse_exited():
	$stats_tt.hide()
