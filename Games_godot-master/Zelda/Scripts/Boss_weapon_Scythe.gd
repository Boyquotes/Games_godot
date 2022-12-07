extends KinematicBody2D

var dir
var test_dir
var move_speed = 2

func _ready():
	dir = self.get_parent().position.direction_to(GV.GV["player"].position)
	
func _physics_process(delta):
	
	position += dir * move_speed

func _on_coll_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		body.bleed_damage(2)
