extends Node2D

func _ready():
	GV.Boss["boss_type"] = ResourceLoader.load("res://Scenes/" + GV.Boss["load_boss"] + ".tscn").instance()
	GV.Scene["current_scene"].add_child(GV.Boss["boss_type"])
	GV.Boss["boss_type"].position = $Boss_Spawn.position
	GV.Enemy["enemy_entites"].clear()
	GV.Enemy["enemy_entites"].push_front(GV.Boss["boss_type"])
#
	GV.Enemy["enemy_pos"].push_front(Vector2(GV.Boss["boss_type"].position.x, GV.Boss["boss_type"].position.y))
	GV.Enemy["enemy_dir"].push_front(Vector2.RIGHT)
	GV.Enemy["enemy_id"].push_front(str(GV.Boss["boss_type"]))
	GV.Enemy["enemy_hp"].push_front(GV.Boss["boss_hp_modifier"])
	GV.Enemy["enemies"].push_front(GV.Boss["boss_type"])
