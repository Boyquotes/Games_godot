extends Panel

onready var slots = get_children()
var items = {}

func _ready():
	for slot in slots:
		items[slot.name] = null

func insert_item(pos):
	var item
	for i in Globals.inventory_items:
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
		Globals.player_weapon = item["name"]
		Globals.GUI.attribute_points(Globals.GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("stat_screen").get_node("power").get_node("power"), false, item["id"])
		if item.has("special"):
			GV.Player["player"].special = item["special"]
#		Globals.GUI.attribute_points(Globals.GUI.get_node("stat_screen").get_node("dmg_type").get_node("power"), false, item["id"])
		Globals.current_weapon_id = item["id"]
		
		if Globals.player_weapon == "bow":
			if Globals.current_ammo == null:
				Globals.current_ammo = "standard arrow"
				Globals.GUI.get_node("ammo").text = "standard arrow"
				Globals.GUI.get_node("ammo_num").text = "unl."
		else:
			Globals.current_ammo = null
			Globals.GUI.get_node("ammo").text = ""
			Globals.GUI.get_node("ammo_num").text = ""
		
	if slot == $GLOVES or slot == $BOOTS or slot == $CHARACTER:
		if slot == $CHARACTER:
			GV.Player["player"].get_node("Body_Armor").texture = ResourceLoader.load("res://Assets/items/" + item.name + ".png")
			Globals.current_body_armor_id = item["id"]
		if slot == $BOOTS:
			Globals.current_boots_id = item["id"]
		if slot == $GLOVES:
			Globals.current_gloves_id = item["id"]
		
		if Globals.add_stats:
			if item.has("special"):
				var mode = "add"
				var item_place = item
				special_mod(item_place, mode)
			
			var GUI_stats = Globals.GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
			Globals.GUI.attribute_points(GUI_stats.get_node("stat_screen").get_node("dex").get_node("dex"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("stat_screen").get_node("int").get_node("intel"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("stat_screen").get_node("str").get_node("stren"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("fire").get_node("fire"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("cold").get_node("cold"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("lightning").get_node("lightning"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("physical").get_node("physical"), false, item["id"])
			Globals.GUI.attribute_points(GUI_stats.get_node("item_stats").get_node("res").get_node("poison").get_node("poison"), false, item["id"])

			Globals.add_stats = false
		else:
			return
	
	if slot == $POWERUP:
		Globals.GUI.buff_effects(item.name, "activate")
	
	return true
	

func grab_item(pos):
	var item = get_item_under_pos(pos)
	var inventory_item
	if item == null:
		return null
	var GUI_stats = Globals.GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI")
	var item_slot
	var item_id
	for i in Globals.inventory_items:
		if item.get_meta("id") == i["id"]:
			item_slot = i["slot"]
			item_id = i["id"]
			inventory_item = i
	items[item_slot] = null
	
	if item_slot == "WEAPON":
		Globals.player_weapon = null
		Globals.GUI.remove_points(GUI_stats.get_node("stat_screen").get_node("power").get_node("power"), item_id)
	elif item_slot == "CHARACTER" or item_slot == "GLOVES" or item_slot == "BOOTS":
		if item_slot == "CHARACTER":
			GV.Player["player"].get_node("Body_Armor").texture = null
			
		if inventory_item.has("special"):
			var mode = "deduct"
			var item_place = inventory_item
			special_mod(item_place, mode) 

		Globals.GUI.remove_points(GUI_stats.get_node("stat_screen").get_node("dex").get_node("dex"), item_id)
		Globals.GUI.remove_points(GUI_stats.get_node("stat_screen").get_node("int").get_node("intel"), item_id)
		Globals.GUI.remove_points(GUI_stats.get_node("stat_screen").get_node("str").get_node("stren"), item_id)		
		Globals.GUI.remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("fire").get_node("fire"), item_id)
		Globals.GUI.remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("cold").get_node("cold"), item_id)
		Globals.GUI.remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("lightning").get_node("lightning"), item_id)
		Globals.GUI.remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("physical").get_node("physical"), item_id)
		Globals.GUI.remove_points(GUI_stats.get_node("item_stats").get_node("res").get_node("poison").get_node("poison"), item_id)

	elif item_slot == "POWERUP":
		Globals.GUI.buff_effects(item, "deactivate")

	return item
	
	
func special_mod(item, mode):
	if "quality" in item["special"][0]:
		if mode == "add":
			Globals.quality += item["special"][1]
		else:
			Globals.quality -= item["special"][1]
		Globals.GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("loot_modifiers").get_node("qual_num").text =  str(Globals.quality)
	if "quantity" in item["special"][0]:
		if mode == "add":
			Globals.quantity += item["special"][1]
		else:
			Globals.quantity -= item["special"][1]
		Globals.GUI.get_node("gui_container").get_node("stat_inv_margin_container").get_node("stat_inv_container").get_node("stat_GUI").get_node("loot_modifiers").get_node("quant_num").text = str(Globals.quantity)
	if item["special"][0] == "mana_reg":
		if mode == "add":
			Globals.GUI.get_node("mana_progress").step += 1
		else:
			Globals.GUI.get_node("mana_progress").step -= 1
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
