extends Area2D

var speed = 2
var velocity
var proj

func _ready():
	if "poison" in self.name:
		var dir_to_player = (GV.Player["player"].global_position - $proj_pos.position).normalized()
		var angle = atan2(dir_to_player.y, dir_to_player.x)
		self.rotation_degrees = (angle*(180/PI)+180)
		velocity = dir_to_player

func _physics_process(delta):
	position += velocity * speed

func _on_poison_proj_body_entered(body):	
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		Globals.damage_type = "poison"
		GV.Player["player"].get_node("poison_timer").start()
		var poison_dmg_timer = Timer.new()
		Globals.poison_stacks += 1
		poison_dmg_timer.name = "poison_dmg_timer"
		poison_dmg_timer.connect("timeout", GV.Player["player"], "_on_poison_dmg_timer_timeout", [ Globals.poison_stacks ])
		GV.Player["player"].add_child(poison_dmg_timer)
		GV.Player["player"].get_node(poison_dmg_timer.name).start()

		self.queue_free()

func _on_thorn_proj_body_entered(body):
	if "Level_TileMap" in body.name:
		self.queue_free()
	elif "Player" in body.name:
		Globals.damage_type = "physical"
		body.bleed_damage(2)
		
		self.queue_free()
		

