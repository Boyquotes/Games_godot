extends Container

var button_id = 0
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
	for i in tasks.size():
		if tasks[i] == chosen_task:
			if task_suggestion == false:
				var current_task_button = Button.new()
				var current_task_label = Label.new()
				var confirm_task_label = Label.new()
				$current_task.add_child(current_task_label)
				$current_task.add_child(current_task_button)
				$current_task.get_child(1).name = "complete_task_button"
				$current_task.get_child(0).name = "current_task_label"
				$current_task/complete_task_button.add_child(confirm_task_label)
				$current_task/complete_task_button.get_child(0).name = "complete_task_label"
				$current_task/complete_task_button/complete_task_label.text = "click to end task"
				$current_task/complete_task_button/complete_task_label.set_align(HALIGN_CENTER)
				$current_task/complete_task_button/complete_task_label.set_valign(VALIGN_CENTER)
				$current_task/complete_task_button/complete_task_label.rect_size.x = 800
				$current_task/complete_task_button/complete_task_label.rect_size.y = 20
				$current_task/current_task_label.set_align(HALIGN_CENTER)
				$current_task/current_task_label.set_valign(VALIGN_CENTER)
				$current_task/current_task_label.rect_size.x = 800
				$current_task/current_task_label.rect_size.y = 20
				$current_task/current_task_label.text = chosen_task
				$current_task/complete_task_button.rect_size.x = 800
				$current_task/complete_task_button.rect_size.y = 20
				$suggested_task/choose_task_button/Label.text = "Click to get another suggestion"
				task_suggestion = true
				$current_task/complete_task_button.connect("pressed", self, "_on_current_task_button_pressed")
				break
			else:
				$current_task/current_task_label.text = chosen_task
	
func _on_current_task_button_pressed():
	var completed_task = RichTextLabel.new()
	
	$completed_task.add_child(completed_task)
	$completed_task.get_children()[-1].bbcode_enabled = true
	$completed_task.get_children()[-1].rect_min_size.y = 20
	$completed_task.get_children()[-1].append_bbcode("[s]"+$current_task/current_task_label.text+"[/s]")
	delete_task($current_task/current_task_label.text)
	$current_task/current_task_label.text = ""
	
func delete_task(task):
	var f = File.new()
	f.open("res://task_selector.txt", File.READ)
	var tasks = f.get_as_text().split(",")
	
	for i in tasks.size():
		if tasks[i] == task:
			tasks.remove(i)
			f.open("res://task_selector.txt", File.WRITE)
			#tasks.join(",")
			#f.store_string(tasks)
			f.store_csv_line(tasks, ",")
			print("tasks ", f)
			f.close()
			break
		
			
			
			
# todo: invisible ("styled" buttons so it is not necessary to do that when adding the content via code
# todo: remove space from last item in task file after first WRITE to File
	
	
