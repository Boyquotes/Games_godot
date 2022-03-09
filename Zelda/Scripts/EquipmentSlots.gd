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
		Globals.GUI.attribute_points(Globals.GUI.get_node("stat_screen").get_node("power").get_node("power"), false, item["id"])
		Globals.current_weapon_id = item["id"]
		
	if slot == $CHARACTER:
		Globals.GUI.attribute_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"), false, item["id"])
		Globals.GUI.attribute_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("intel"), false, item["id"])
		Globals.GUI.attribute_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("stren"), false, item["id"])
		Globals.current_armor_id = item["id"]
		
		Globals.GUI.attribute_points(Globals.GUI.get_node("res").get_node("fire").get_node("fire"), false, item["id"])
		Globals.GUI.attribute_points(Globals.GUI.get_node("res").get_node("cold").get_node("cold"), false, item["id"])
		Globals.GUI.attribute_points(Globals.GUI.get_node("res").get_node("lightning").get_node("lightning"), false, item["id"])
		Globals.GUI.attribute_points(Globals.GUI.get_node("res").get_node("physical").get_node("physical"), false, item["id"])
		Globals.GUI.attribute_points(Globals.GUI.get_node("res").get_node("poison").get_node("poison"), false, item["id"])
	
	return true

func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
		
	var item_slot
	var item_id
	for i in Globals.inventory_items:
		if item.get_meta("id") == i["id"]:
			item_slot = i["slot"]
			item_id = i["id"]
	items[item_slot] = null
	if item_slot == "WEAPON":
		Globals.player_weapon = null
		Globals.GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("power").get_node("power"), item_id)
	elif item_slot == "CHARACTER":
		Globals.GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"), item_id)
		Globals.GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("intel"), item_id)
		Globals.GUI.remove_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("stren"), item_id)
		
		Globals.GUI.remove_points(Globals.GUI.get_node("res").get_node("fire").get_node("fire"), item_id)
		Globals.GUI.remove_points(Globals.GUI.get_node("res").get_node("cold").get_node("cold"), item_id)
		Globals.GUI.remove_points(Globals.GUI.get_node("res").get_node("lightning").get_node("lightning"), item_id)
		Globals.GUI.remove_points(Globals.GUI.get_node("res").get_node("physical").get_node("physical"), item_id)
		Globals.GUI.remove_points(Globals.GUI.get_node("res").get_node("poison").get_node("poison"), item_id)
		

	return item

func get_slot_under_pos(pos):
	return get_thing_under_pos(slots, pos)

func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)

func get_thing_under_pos(arr, pos):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
