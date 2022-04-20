extends Node2D


func _ready():
	pass

func _on_free_web_timeout():
	self.queue_free()
