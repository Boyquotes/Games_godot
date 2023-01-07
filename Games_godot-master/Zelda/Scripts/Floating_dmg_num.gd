extends Position2D

onready var tween = get_node("dmg_num_anim")

func _ready():
	
	self.position.y -= 30
	self.position.x -= 10
	
	tween.interpolate_property(self, "position", null, Vector2(self.position.x -10, self.position.y -50), 2.0, Tween.TRANS_LINEAR)  
	tween.start()

func _on_dmg_num_anim_tween_all_completed():
	self.queue_free()
