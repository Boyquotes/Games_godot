extends KinematicBody2D

var move_speed = 3
var anim_enemy
var burning = false

func _ready():
	pass

func _physics_process(delta):
	
	if Globals.current_scene.name == "Starting_World":
		attack_movement(self)
	
func attack_movement(body):
	anim_enemy = $AnimationPlayer
#	move_speed = 3
	var dir = body.position.direction_to(Globals.player.position)
	var attack_coll = move_and_collide(Vector2.move_toward(dir, move_speed))
	anim_enemy.play("attack")
	if dir.x > 0:
		$Body.set_flip_h(true)
	else:
		$Body.set_flip_h(false)
		
func unfreeze_timer():
	yield(get_tree().create_timer(2), "timeout")
	move_speed = 3
	
func burn_timer(curr_enemy):
	if burning == false:
		for i in 5:
			burning = true
			yield(get_tree().create_timer(2), "timeout")
			Globals.enemy_hp[curr_enemy] -= 20
			$enemy_hp_bar.value -= 20
			if Globals.enemy_hp[curr_enemy] <= 0:
				remove_enemy(curr_enemy)
		!burning
		
func remove_enemy(i):
	var lvl_progress = Globals.GUI.get_node("lvl_progress")

	Globals.enemy_id.remove(i)
	Globals.enemy_pos.remove(i)
	Globals.enemy_hp.remove(i)
	Globals.enemies.remove(i)
	Globals.enemy_tracker -= 1
	Globals.drop(self.position)
	Globals.GUI.get_node("number").text = str(Globals.enemy_tracker)
	if lvl_progress.value == (lvl_progress.max_value-lvl_progress.step):
		var curr_lvl = int(Globals.GUI.get_node("lvl").text)
		curr_lvl += 1
		Globals.GUI.get_node("lvl").text = str(curr_lvl)
		Globals.player_lvl = curr_lvl
		lvl_progress.value = 0
		Globals.current_scene.get_node("GUI").get_node("lvl_up").visible = true
		var lvlupstats = int(Globals.current_scene.get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text) 
		lvlupstats += 5
		Globals.current_scene.get_node("GUI").get_node("stat_screen").get_node("points").get_node("points_num").text = str(lvlupstats)
	else:
		lvl_progress.value += lvl_progress.step
	self.queue_free()
	
	
