extends TextureButton


func _ready():
	pass 

func _on_lvl_up_pressed():
	
	self.visible = false
	self.get_parent().get_node("stat_container").get_node("stat_screen").visible = true
	
	
