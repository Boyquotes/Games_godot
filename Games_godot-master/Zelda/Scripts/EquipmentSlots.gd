extends Panel

onready var slots = get_children()
var items = {}

func _ready():
	for slot in slots:
		items[slot.name] = null

func insert_item(pos):
	var item
	for i in GV.Item["inventory_items"]:
		if pos.get_meta("id") == i["id"]:
			item = i
	
	var item_pos = pos.rect_global_position + pos.rect_size / 2
	var slot = self.get_node(item["slot"])

	if slot == null:
		return false
	
	var item_slot = item["slot"]
	if item_slot != slot.name:
		return false
	if items[item_slot] != null:
		return false
		
	items[item_slot] = pos
	pos.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - pos.rect_size / 2
	
	if slot == $WEAPON:
		GV.Player["player_weapon"] = item["name"]
		GV.GUI["GUI"].attribute_points(GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("stat_screen").get_node("power").get_node("power"), false, item["id"])
		if item.has("special"):
			print("equipSpecial ", item["special"])
			GV.Player["player"].special = item["special"]
#		GV.GUI["GUI"].attribute_points(GV.GUI["GUI"].get_node("stat_screen").get_node("dmg_type").get_node("power"), false, item["id"])
		GV.Item["current_weapon_id"] = item["id"]
		
		if GV.Player["player_weapon"] == "bow":
			if GV.Item["current_ammo"] == null:
				GV.Item["current_ammo"] = "standard arrow"
				GV.GUI["GUI"].get_node("ammo").text = "standard arrow"
				GV.GUI["GUI"].get_node("ammo_num").text = "unl."
		else:
			GV.Item["current_ammo"] = null
			GV.GUI["GUI"].get_node("ammo").text = ""
			GV.GUI["GUI"].get_node("ammo_num").text = ""
		
	if slot == $GLOVES or slot == $BOOTS or slot == $CHARACTER:
		if slot == $CHARACTER:
			GV.Player["player"].get_node("Body_Armor").texture = ResourceLoader.load("res://Assets/items/" + item.name + ".png")
			GV.Item["current_body_armor_id"] = item["id"]
		if slot == $BOOTS:
			GV.Item["current_boots_id"] = item["id"]
		if slot == $GLOVES:
			GV.Item["current_gloves_id"] = item["id"]
		
		if GV.GUI["add_stats"]:
			if item.has("special"):
				var mode = "add"
				var item_place = item
				special_mod(item_place, mode)
			
			var GUI_stats = GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("stat_screen").get_node("dex").get_node("dex"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("stat_screen").get_node("int").get_node("intel"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("stat_screen").get_node("str").get_node("stren"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("fire").get_node("fire"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("cold").get_node("cold"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("lightning").get_node("lightning"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("physical").get_node("physical"), false, item["id"])
			GV.GUI["GUI"].attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("poison").get_node("poison"), false, item["id"])

			GV.GUI["add_stats"] = false
		else:
			return
	
	if slot == $POWERUP:
		GV.GUI["GUI"].buff_effects(item.name, "activate")
	
	return true
	

func grab_item(pos):
	var item = get_item_under_pos(pos)
	var inventory_item
	if item == null:
		return null
	var GUI_stats = GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
	var item_slot
	var item_id
	for i in GV.Item["inventory_items"]:
		if item.get_meta("id") == i["id"]:
			item_slot = i["slot"]
			item_id = i["id"]
			inventory_item = i
	items[item_slot] = null
	
	if item_slot == "WEAPON":
		GV.Player["player_weapon"] = null
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("stat_screen").get_node("power").get_node("power"), item_id)
	elif item_slot == "CHARACTER" or item_slot == "GLOVES" or item_slot == "BOOTS":
		if item_slot == "CHARACTER":
			GV.Player["player"].get_node("Body_Armor").texture = null
			
		if inventory_item.has("special"):
			var mode = "deduct"
			var item_place = inventory_item
			special_mod(item_place, mode) 

		GV.GUI["GUI"].remove_points(GUI_stats.get_node("stat_screen").get_node("dex").get_node("dex"), item_id)
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("stat_screen").get_node("int").get_node("intel"), item_id)
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("stat_screen").get_node("str").get_node("stren"), item_id)		
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("fire").get_node("fire"), item_id)
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("cold").get_node("cold"), item_id)
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("lightning").get_node("lightning"), item_id)
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("physical").get_node("physical"), item_id)
		GV.GUI["GUI"].remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("poison").get_node("poison"), item_id)

	elif item_slot == "POWERUP":
		GV.GUI["GUI"].buff_effects(item, "deactivate")

	return item
	
	
func special_mod(item, mode):
	if "quality" in item["special"][0]:
		if mode == "add":
			GV.Item["quality"] += item["special"][1]
		else:
			GV.Item["quality"] -= item["special"][1]
		GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("loot_modifiers").get_node("qual_num").text =  str(GV.Item["quality"])
	if "quantity" in item["special"][0]:
		if mode == "add":
			GV.Item["quantity"] += item["special"][1]
		else:
			GV.Item["quantity"] -= item["special"][1]
		GV.GUI["GUI"].get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("loot_modifiers").get_node("quant_num").text = str(GV.Item["quantity"])
	if item["special"][0] == "mana_reg":
		if mode == "add":
			GV.GUI["GUI"].get_node("mana_progress").step += 1
		else:
			GV.GUI["GUI"].get_node("mana_progress").step -= 1
	if item["special"][0] == "life_reg":
		if mode == "add":
			GV.Player["player"].get_node("life_fill_timer").start()
		else:
			GV.Player["player"].get_node("life_fill_timer").stop()

func get_slot_under_pos(pos):
	return get_thing_under_pos(slots, pos)

func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)

func get_thing_under_pos(arr, pos):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
