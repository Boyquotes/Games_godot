extends Node2D

func _ready():
	GV.Boss["boss_type"] = ResourceLoader.load("res://Scenes/" + GV.Boss["load_boss"] + ".tscn").instance()
	GV.Scenes["current_scene"].add_child(GV.Boss["boss_type"])
	GV.Boss["boss_type"].position = $Boss_Spawn.position
	Globals.entities.clear()
	Globals.entities.push_front(GV.Boss["boss_type"])
#
	Globals.enemy_pos.push_front(Vector2(GV.Boss["boss_type"].position.x, GV.Boss["boss_type"].position.y))
	Globals.enemy_dir.push_front(Vector2.RIGHT)
	Globals.enemy_id.push_front(str(GV.Boss["boss_type"]))
	Globals.enemy_hp.push_front(GV.Boss["boss_hp_modifier"])
	Globals.enemies.push_front(GV.Boss["boss_type"])
