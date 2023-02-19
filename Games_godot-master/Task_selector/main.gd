extends Node2D


func _ready():
	random_task()
	
func populate_tasks():
	var f = File.new()
	f.open("res://task_selector.txt", File.READ)
	return f.get_as_text().split(",")
	
func random_task():
	var tasks = populate_tasks()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	$Container/Panel/Button/Label.text = tasks[rand.randf_range(0, tasks.size())]
	
func _on_Button_pressed():
	var chosen_task = $Container/Panel/Button/Label.text
	var tasks = populate_tasks()
	for i in tasks.size():
		if tasks[i] == chosen_task:
			var done_task = Label.new()
			$Container/MarginContainer.add_child(done_task)
			done_task.text = chosen_task
			tasks.remove(i)
			break
	print(tasks)
	#print(tasks.find(chosen_task))
	
