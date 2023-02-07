extends StaticBody2D

#var inv_item_compare = null

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("compare"):
		if "pwrup" in self.name:
			$drop_stats_tt/stats_tt_pop_up/stats/compare_container.visible = false
		else:
			$drop_stats_tt/stats_tt_pop_up/stats/compare_container.visible = true
			if "chest" in $drop_stats_tt/stats_tt_pop_up/stats/item_name.text:
				for i in GV.Item["inventory_items"]:
					if "chest" in i["icon"] and i["id"] == GV.Item["current_body_armor_id"]:
						compare_stats_on_drop(i)
			elif "boots" in $drop_stats_tt/stats_tt_pop_up/stats/item_name.text:
				for i in GV.Item["inventory_items"]:
					if "boots" in i["icon"] and i["id"] == GV.Item["current_boots_id"]:
						compare_stats_on_drop(i)
			elif "gloves" in $drop_stats_tt/stats_tt_pop_up/stats/item_name.text:
				for i in GV.Item["inventory_items"]:
					if "gloves" in i["icon"] and i["id"] == GV.Item["current_gloves_id"]:
						compare_stats_on_drop(i)
	else:
		$drop_stats_tt/stats_tt_pop_up/stats/compare_container.visible = false

func compare_stats_on_drop(inv_item_to_compare):
#	var drop_stats = $drop_stats_tt/stats_tt_pop_up/stats/stats_container
#	var inv_stats = $drop_stats_tt/stats_tt_pop_up/stats/compare_container
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_str.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/str/value.text) - int(inv_item_to_compare["stren"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_dex.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/dex/value.text) - int(inv_item_to_compare["dex"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_int.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/int/value.text) - int(inv_item_to_compare["intel"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_fire.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/res/fire/value.text) - int(inv_item_to_compare["fire"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_cold.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/res/cold/value.text) - int(inv_item_to_compare["cold"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_lightning.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/res/lightning/value.text) - int(inv_item_to_compare["lightning"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_physical.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/res/physical/value.text) - int(inv_item_to_compare["cold"]))
	$drop_stats_tt/stats_tt_pop_up/stats/compare_container/comp_poison.text = str(int($drop_stats_tt/stats_tt_pop_up/stats/stats_container/res/poison/value.text) - int(inv_item_to_compare["poison"]))

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
		$drop_stats_tt/stats_tt_pop_up.rect_position = Vector2(700, 350)
		$drop_stats_tt/stats_tt_pop_up.show()
		
func _on_drop_mouse_exited():
	$drop_stats_tt/stats_tt_pop_up.hide()

func _on_Despawn_Timer_timeout():
	
	if "Boss" in GV.Scene["current_scene"].name:
		return
	else:
		for i in GV.Item["dropped_items"]:
			if i["id"] == int($id.text):
				GV.Item["dropped_items"].remove(GV.Item["dropped_items"].find(i))
	
		self.queue_free()
