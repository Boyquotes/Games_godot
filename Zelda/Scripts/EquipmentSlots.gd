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
		
	if slot == $CHARACTER:
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"), false, item["id"])
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("int"), false, item["id"])
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("str"), false, item["id"])
	
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
	elif item_slot == "CHARACTER":
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"), item_id)
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("int"), item_id)
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("str"), item_id)

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
