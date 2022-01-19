extends Panel

onready var slots = get_children()
var items = {}

func _ready():
	for slot in slots:
		items[slot.name] = null

func insert_item(item, pos):
	var item_pos = pos.rect_global_position + pos.rect_size / 2
#	var slot = get_slot_under_pos(item_pos)
	var slot = self.get_node(item["slot"])

	if slot == null:
		return false
	
	var item_slot = item["slot"]
	if item_slot != slot.name:
		return false
	if items[item_slot] != null:
		return false
		
	print("items ", items)

	items[item_slot] = item
	pos.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - pos.rect_size / 2
	
	if slot == $WEAPON:
		Globals.player_weapon = item["name"]
		
	if slot == $CHARACTER:
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"), false)
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("int"), false)
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("str"), false)
		
	print("items ", items)
	
	return true

func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
	
	var item_slot = item["slot"]
	items[item_slot] = null
	if item_slot == "WEAPON":
		Globals.player_weapon = null
	elif item_slot == "CHARACTER":
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("dex").get_node("dex"))
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("int").get_node("int"))
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("str").get_node("str"))

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
