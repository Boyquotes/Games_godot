extends Area2D

var speed = 2
var velocity
var proj

func _ready():

	var dir_to_player = (Globals.player.global_position - $proj_pos.position).normalized()
	var angle = atan2(dir_to_player.y, dir_to_player.x)
	self.rotation_degrees = (angle*(180/PI)+180)
	velocity = dir_to_player

func _physics_process(delta):
	position += velocity * speed

func _on_poison_proj_body_entered(body):
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		body.hp -= 25
		Globals.GUI.get_node("hp_num").text = str(body.hp)
		Globals.player_hp = body.hp
		self.queue_free()
