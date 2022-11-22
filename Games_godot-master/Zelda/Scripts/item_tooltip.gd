extends StaticBody2D

func _ready():
	pass
	
func _process(delta):
	pass

func _on_drop_mouse_entered():
#	if Input.is_action_pressed("showTT"):
#		if !$stats_tt.visible:
#			$stats_tt.rect_position = self.position
#			$stats_tt.show()
#		else:
#			$stats_tt.hide()
#	print(self.name)
	if "pwrup" in self.name:
		return
	else:
		$drop_stats_tt/stats_tt_pop_up.rect_position = Vector2(600, 200)
		$drop_stats_tt/stats_tt_pop_up.show()

func _on_drop_mouse_exited():
	$drop_stats_tt/stats_tt_pop_up.hide()

func _on_Despawn_Timer_timeout():
	
	if "Boss" in Globals.current_scene.name:
		return
	else:
		for i in Globals.dropped_items:
			if i["id"] == int($id.text):
				Globals.dropped_items.remove(Globals.dropped_items.find(i))
	
		self.queue_free()
