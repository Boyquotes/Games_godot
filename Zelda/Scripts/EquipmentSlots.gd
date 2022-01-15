extends Panel

onready var slots = get_children()
var items = {}

func _ready():
	for slot in slots:
		items[slot.name] = null

func insert_item(item):
	var item_pos = item.rect_global_position + item.rect_size / 2
#	var slot = get_slot_under_pos(item_pos)
	var slot = self.get_node(ItemDB.get_item(item.get_meta("id"))["slot"])

	if slot == null:
		return false
	
	var item_slot = ItemDB.get_item(item.get_meta("id"))["slot"]
	if item_slot != slot.name:
		return false
	if items[item_slot] != null:
		return false
		
	items[item_slot] = item
	item.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - item.rect_size / 2
	
	if slot == $WEAPON:
		Globals.player_weapon = ItemDB.get_item(item.get_meta("id"))["name"]
		
	if slot == $CHARACTER:
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("dexterity").get_node("dexterity"), false)
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("intelligence").get_node("intelligence"), false)
		Globals.GUI.get_node("stat_screen").attribute_points(Globals.GUI.get_node("stat_screen").get_node("strength").get_node("strength"), false)

	
	return true

func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
	
	var item_slot = ItemDB.get_item(item.get_meta("id"))["slot"]
	items[item_slot] = null
	if item_slot == "WEAPON":
		Globals.player_weapon = null
	elif item_slot == "CHARACTER":
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("dexterity").get_node("dexterity"))
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("intelligence").get_node("intelligence"))
		Globals.GUI.get_node("stat_screen").remove_points(Globals.GUI.get_node("stat_screen").get_node("strength").get_node("strength"))

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
