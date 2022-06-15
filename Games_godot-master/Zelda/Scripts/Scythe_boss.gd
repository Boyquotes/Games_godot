extends KinematicBody2D

var dir
var test_dir
var move_speed = 2

func _ready():
	dir = self.get_parent().position.direction_to(Globals.player.position)
	
func _physics_process(delta):
#	dir = self.get_parent().position.direction_to(Globals.player.position)
#	move_and_collide(Vector2.move_toward(test_dir, move_speed))
	
	position += dir * move_speed

func _on_coll_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		body.bleed_damage(2)
