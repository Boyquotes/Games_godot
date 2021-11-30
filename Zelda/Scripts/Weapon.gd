extends Area2D

var speed = 3.5
var velocity = Vector2.ZERO
var life_time = 3

func _ready():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()
	
func _physics_process(delta):
	position += velocity * speed

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if "Enemy" in body.name:
		var lvl_progress = Globals.GUI.get_node("lvl_progress")
		var enemy_hp_bar = body.get_node("enemy_hp_bar")
		for i in Globals.enemy_pos.size():
			if str(body) == Globals.enemy_id[i]:
				if "axe" in self.get_node("weapon").texture.get_path():
					Globals.enemy_hp[i] -= (Globals.player_pwr*2)
				else: 
					Globals.enemy_hp[i] -= Globals.player_pwr
					
				enemy_hp_bar.visible = true
				enemy_hp_bar.value -= Globals.player_pwr
						
				if Globals.enemy_hp[i] <= 0:
					Globals.enemy_id.remove(i)
					Globals.enemy_pos.remove(i)
					Globals.enemy_hp.remove(i)
					Globals.enemy_tracker -= 1
					Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)
					body.queue_free()
					if lvl_progress.value == (lvl_progress.max_value-lvl_progress.step):
						var curr_lvl = int(Globals.GUI.get_node("lvl").text)
						curr_lvl += 1
						Globals.GUI.get_node("lvl").text = str(curr_lvl)
						Globals.player_lvl = str(curr_lvl)
						lvl_progress.value = 0
						if int(Globals.player_lvl)%2 == 0 and int(Globals.player_lvl) != 0:
							Globals.player_pwr += 50
							print("new player pwr ", Globals.player_pwr)
					else:
						lvl_progress.value += lvl_progress.step

					break

				Globals.player_xp = lvl_progress.value
				
				if Globals.enemy_tracker == 0:
					Globals.boss = ResourceLoader.load("res://Scenes/boss.tscn").instance()
					Globals.boss.position.x = 500
					Globals.boss.position.y = 250
					Globals.current_scene.call_deferred("add_child", Globals.boss)

	if "boss" in body.name:
		Globals.boss.queue_free()
		Globals.goto_scene("res://Scenes/game_won_screen.tscn", "null")
		Globals.num_of_enemies(1)
