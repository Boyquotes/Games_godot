extends Area2D

var speed = 1
var velocity
var life_time = 10

func _ready():
	$Weapon_Timeout.set_wait_time(life_time)
	$Weapon_Timeout.start()
	
	velocity = Vector2(1,0)
	
func _physics_process(delta):
	position += velocity * speed
	
func _on_poison_proj_body_entered(body):
	if "Level_TileMap" in body.name:
		$reload_timer.start()
	elif "Player" in body.name:
		body.hp -= 25
		Globals.GUI.get_node("hp_num").text = str(body.hp)
		Globals.player_hp = body.hp
		$reload_timer.start()

func _on_Weapon_Timeout_timeout():
	$reload_timer.start()

func _on_reload_timer_timeout():
	self.queue_free()
	var proj = load("res://Scenes/snake_proj.tscn").instance()
	self.get_parent().add_child(proj)
#	Globals.current_scene.add_child(proj)
	
#func attack_player():
#	var dir = self.position.direction_to(Globals.player.position)
#	self.position = dir
#	position += velocity * speed
#	var attack_coll = move_and_collide(Vector2.move_toward(dir, speed))
	
	
	


