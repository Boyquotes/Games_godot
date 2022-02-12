extends Area2D

var speed = 2
var velocity
var life_time = 5
var proj

func _ready():
	self.global_position = self.get_parent().global_position
	
	var dir_to_player = (Globals.player.global_position - self.get_parent().global_position).normalized()
	velocity = dir_to_player
#	self.rotation_degrees = (dir_to_player.x/dir_to_player.y)*100
	$fire.set_wait_time(life_time)
	$fire.start()
	
func _physics_process(delta):
	position += velocity * speed
	
func _on_poison_proj_body_entered(body):
	if "Level_TileMap" in body.name:
		fire()
	elif "Player" in body.name:
		body.hp -= 25
		Globals.GUI.get_node("hp_num").text = str(body.hp)
		Globals.player_hp = body.hp
		fire()
		
func fire():
	self.queue_free()
	proj = load("res://Scenes/snake_proj.tscn").instance()
	self.get_parent().call_deferred("add_child", proj)
	
func _on_fire_timeout():
	fire()



