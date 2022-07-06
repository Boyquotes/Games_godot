extends KinematicBody2D

var dir
var test_dir
var move_speed = 4
var attack_mode
var velocity = Vector2()

func _ready():	
	var arrow_pos = self.get_parent().get_node("boss_bow").position
	
	if attack_mode == "single":
		var dir_to_player = (Globals.player.global_position - arrow_pos).normalized()
		var angle = atan2(dir_to_player.y, dir_to_player.x)
		self.rotation_degrees = (angle*(180/PI)+180)
		dir = dir_to_player * move_speed
	elif attack_mode == "multi":
		if Globals.current_scene.get_node("boss_bow").get_node("boss_sprite").is_flipped_h() == false:
			dir = Vector2(1,0).rotated(rotation) * move_speed
		else:
			dir = Vector2(-1,0).rotated(rotation) * move_speed

func _physics_process(delta):
	
	position += dir

func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		print("bow_hit")
		self.queue_free()
#		body.bleed_damage(2)
