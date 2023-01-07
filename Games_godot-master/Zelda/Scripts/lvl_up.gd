extends TextureButton


func _ready():
	pass 

func _on_lvl_up_pressed():
	
	self.visible = false
	
	GV.Scene["current_scene"].get_node("GUI").get_node("points_container").visible = true
	GV.Scene["current_scene"].get_node("GUI").get_node("gui_container").visible = true
	
	
