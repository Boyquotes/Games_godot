extends Control

func _process(delta):
	if Input.is_action_just_pressed("start"):
		GF.goto_scene("res://Scenes/Levels/Starting_World.tscn", self.name)
		GF.num_of_enemies(50)
