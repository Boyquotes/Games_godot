extends Control

const item_base = preload("res://Scenes/ItemBase.tscn")

onready var inv_base = $InventoryBase
onready var grid_bkpk = $InventoryBase/GridBackPack
onready var eq_slots = $InventoryBase/EquipmentSlots

var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos = Vector2()
var weap_slot_taken = false
var char_slot_taken = false
var pwr_slot_taken = false
var glove_slot_taken = false
var boot_slot_taken = false

func _ready():
	if GV.Item["inventory_items"].size() > 0:
#		weap_slot_taken = false
		for i in GV.Item["inventory_items"]:
			if i["id"] == GV.Item["current_weapon_id"]:
				pickup_item(i)
				break
		for i in GV.Item["inventory_items"]:
			if i["id"] == GV.Item["current_body_armor_id"]:
				pickup_item(i)
				break
		for i in GV.Item["inventory_items"]:
			if i["id"] == GV.Item["current_boots_id"]:
				pickup_item(i)
				break
		for i in GV.Item["inventory_items"]:
			if i["id"] == GV.Item["current_gloves_id"]:
				pickup_item(i)
				break
		for i in GV.Item["inventory_items"]:
			if i["id"] != GV.Item["current_body_armor_id"] and i["id"] != GV.Item["current_weapon_id"] and i["id"] != GV.Item["current_gloves_id"] and i["id"] != GV.Item["current_boots_id"]:
				pickup_item(i)
		return

func _process(delta):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("inv_grab"):
		grab(cursor_pos)
	if Input.is_action_just_released("inv_grab"):
		release(cursor_pos)
	if item_held != null:
		item_held.rect_global_position = cursor_pos + item_offset

func grab(cursor_pos):
	var c = get_container_under_cursor(cursor_pos)
	if c != null and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos)
		if item_held != null:
			last_container = c
			last_pos = item_held.rect_global_position
			item_offset = item_held.rect_global_position - cursor_pos
			move_child(item_held, get_child_count())

func release(cursor_pos):
	if item_held == null:
		return
	var c = get_container_under_cursor(cursor_pos)
	if c == null:
		drop_item()
	elif c.has_method("insert_item"):
		GV.GUI["add_stats"] = true
		if c.insert_item(item_held):
			item_held = null
		else:
			return_item()
	else:
		return_item()
	GV.GUI["add_stats"] = false
		

func get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, inv_base]
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null

func drop_item():
	for i in GV.Item["inventory_items"]:
		if item_held.get_meta("id") == i["id"]:
			GV.Item["inventory_items"].remove(GV.Item["inventory_items"].find(i))
	item_held.queue_free()
	item_held = null

func return_item():
	item_held.rect_global_position = last_pos
	last_container.insert_item(item_held)
	item_held = null

func pickup_item(item_id):
	var item = item_base.instance()
	item.set_meta("id", item_id["id"])
	item.texture = load(item_id["icon"])
	item.rect_size = Vector2(32, 32)
	item.rect_scale = Vector2(1.6, 1.6)
	item.get_node("type").text = item_id["slot"]
	add_child(item)
	if item_id["slot"] == "CHARACTER" or item_id["slot"] == "GLOVES" or item_id["slot"] == "BOOTS":
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/str/value").text = str(item_id["stren"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/dex/value").text = str(item_id["dex"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/int/value").text = str(item_id["intel"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/res/fire/value").text = str(item_id["fire"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/res/cold/value").text = str(item_id["cold"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/res/lightning/value").text = str(item_id["lightning"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/res/physical/value").text = str(item_id["physical"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/res/poison/value").text = str(item_id["poison"])
		item.get_node("stats_tt/stats_tt_popup/stats/item_name").text = str(item_id["name"])
		if item_id.has("special"):
			item.get_node("stats_tt/stats_tt_popup/stats/stats_container_armor/special_armor_mod").text = str(item_id["special"][0])
	if item_id["slot"] == "WEAPON":
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container/power/value").text = str(item_id["power"])
		if item_id.has("special"):
			item.get_node("stats_tt/stats_tt_popup/stats/stats_container/special_weapon_mod").text = str(item_id["special"])
		item.get_node("stats_tt/stats_tt_popup/stats/stats_container/dmg_type/value").text = str(item_id["dmg_type"])
		item.get_node("stats_tt/stats_tt_popup/stats/item_name").text = str(item_id["name"])
	if item_id["slot"] == "POWERUP":
		item.get_node("stats_tt/stats_tt_popup/stats/item_name").text = str(item_id["name"])
	if !weap_slot_taken and item_id["slot"] == "WEAPON":
		eq_slots.insert_item(item)
		weap_slot_taken = true
	elif !char_slot_taken and item_id["slot"] == "CHARACTER":
		eq_slots.insert_item(item)
		char_slot_taken = true
	elif !char_slot_taken and item_id["slot"] == "POWERUP" and GV.Player["player_weapon"] == "wand":
		eq_slots.insert_item(item)
		pwr_slot_taken = true
	elif !glove_slot_taken and item_id["slot"] == "GLOVES":
		eq_slots.insert_item(item)
		glove_slot_taken = true
	elif !boot_slot_taken and item_id["slot"] == "BOOTS":
		eq_slots.insert_item(item)
		boot_slot_taken = true
	elif !grid_bkpk.insert_item_at_first_available_spot(item):
		item.queue_free()
		return false
	return true
	
