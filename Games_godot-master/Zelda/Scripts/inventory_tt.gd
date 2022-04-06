extends TextureRect

func _ready():
	pass
	
func _process(delta):
	pass

func _on_ItemBase_mouse_entered():
	$stats_tt/stats_tt_popup.rect_position = Vector2(800, 300)
	$stats_tt/stats_tt_popup.show()

func _on_ItemBase_mouse_exited():
	$stats_tt/stats_tt_popup.hide()
