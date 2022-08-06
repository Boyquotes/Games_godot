extends Node2D

func _ready():
	Globals.boss = ResourceLoader.load("res://Scenes/" + Globals.load_boss + ".tscn").instance()
	Globals.current_scene.add_child(Globals.boss)
	Globals.boss.position = $Boss_Spawn.position
	Globals.entities.clear()
	Globals.entities.push_front(Globals.boss)
#
	Globals.enemy_pos.push_front(Vector2(Globals.boss.position.x, Globals.boss.position.y))
	Globals.enemy_dir.push_front(Vector2.RIGHT)
	Globals.enemy_id.push_front(str(Globals.boss))
	Globals.enemy_hp.push_front(Globals.boss_hp_modifier)
	Globals.enemies.push_front(Globals.boss)

	print(Globals.entities)
