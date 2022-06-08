extends Node2D


func _ready():
	Globals.boss = ResourceLoader.load("res://Scenes/boss.tscn").instance()
	Globals.current_scene.add_child(Globals.boss)
	Globals.boss.position = $Boss_Spawn.position
	Globals.entities.clear()
	Globals.entities.push_front(Globals.boss)
