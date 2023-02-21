extends CanvasLayer

var task_suggestion = false

func _ready():
	pass
	#random_task()
	
func populate_tasks():
	var f = File.new()
	f.open("res://task_selector.txt", File.READ)
	var tasks = f.get_as_text().split(",")
	f.close()
	return tasks
	
func random_task():
	var tasks = populate_tasks()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return tasks[rand.randf_range(0, tasks.size())]
	
func _on_choose_task_button_pressed():
	var chosen_task = random_task()
	var tasks = populate_tasks()
	$end_task.visible = true
	
	for i in tasks.size():
		if tasks[i] == chosen_task:
			print(chosen_task)
			if task_suggestion == false:
				$current_task.text = chosen_task
				$suggest_task/choose_task_button/Label.text = "Click to get another suggestion"
				$end_task/end_task_button.connect("pressed", self, "_on_end_task_button_pressed")
				task_suggestion = true
				break
			else:
				$current_task.text = chosen_task
	
func _on_end_task_button_pressed():
	var completed_task = RichTextLabel.new()
	
	$completed_tasks.add_child(completed_task)
	$completed_tasks.get_children()[-1].bbcode_enabled = true
	$completed_tasks.get_children()[-1].rect_min_size.y = 20
	$completed_tasks.get_children()[-1].append_bbcode("[s]"+$current_task.text+"[/s]")
	delete_task($current_task.text)
	$current_task.text = ""
	$end_task.visible = false
	
func delete_task(task):
	var f = File.new()
	f.open("res://task_selector.txt", File.READ_WRITE)
	var tasks = f.get_as_text().split(",")
	
	for i in tasks.size():
		if tasks[i] == task:
			tasks.remove(i)
			f.store_string(tasks.join(","))
			print("tasks ", f)
			f.close()
			break
			
func _on_add_task_button_pressed():
	
	var f = File.new()
	f.open("res://task_selector.txt", File.READ_WRITE)
	var tasks = f.get_as_text().split(",")
	tasks.push_back($add_task/add_task_prompt.text)
	f.store_string(tasks.join(","))
	f.close()
	$add_task/add_task_prompt.text = ""
			
# todo: invisible ("styled" buttons so it is not necessary to do that when adding the content via code
# todo: remove space from last item in task file after first WRITE to File
# todo: handle duplicates
	



