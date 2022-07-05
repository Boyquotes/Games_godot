extends KinematicBody2D

var dir
var test_dir
var move_speed = 4

func _ready():
	var arrow_pos = self.get_parent().get_node("boss_bow").position
	
	var dir_to_player = (Globals.player.global_position - arrow_pos).normalized()
	var angle = atan2(dir_to_player.y, dir_to_player.x)
	self.rotation_degrees = (angle*(180/PI)+180)
	dir = dir_to_player
	
func _physics_process(delta):
	
	position += dir * move_speed

func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		print("bow_hit")
		self.queue_free()
#		body.bleed_damage(2)
