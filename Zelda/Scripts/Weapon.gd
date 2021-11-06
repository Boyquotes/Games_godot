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
	if "Enemy" in body.name:#
		for i in Globals.enemy_pos.size():
			if str(body) == Globals.enemy_id[i]:
				Globals.enemy_id.remove(i)
				Globals.enemy_pos.remove(i)
				Globals.enemy_tracker -= 1
				Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)
				
				if Globals.enemy_tracker == 0:
					Globals.boss = ResourceLoader.load("res://Scenes/boss.tscn").instance()
					Globals.boss.position.x = 500
					Globals.boss.position.y = 250
					Globals.current_scene.call_deferred("add_child", Globals.boss)
				
				body.queue_free()
				break
				
	if "boss" in body.name:
		Globals.boss.queue_free()
		Globals.goto_scene("res://Scenes/game_won_screen.tscn", "null")
		Globals.num_of_enemies(1)
