extends Container

var button_id = 0
var task_suggestion = false

func _ready():
	pass
	#random_task()
	
func populate_tasks():
	var f = File.new()
	f.open("res://task_selector.txt", File.READ)
	return f.get_as_text().split(",")
	
func random_task():
	var tasks = populate_tasks()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return tasks[rand.randf_range(0, tasks.size())]
	#$suggested_task/choose_task_button/Label.text = tasks[rand.randf_range(0, tasks.size())]
	
func _on_choose_task_button_pressed():
	var chosen_task = random_task()
	#$suggested_task/choose_task_button/Label.text
	var tasks = populate_tasks()
	for i in tasks.size():
		if tasks[i] == chosen_task:
			if task_suggestion == false:
				var current_task_button = Button.new()
				var current_task_label = Label.new()
				$current_task.add_child(current_task_label)
				$current_task.add_child(current_task_button)
				$current_task.get_child(1).name = "complete_task_button"
				$current_task.get_child(0).name = "current_task_label"
				#$current_task/current_task_label.get_child(0).name = "current_task_label"
				$current_task/current_task_label.set_align(HALIGN_CENTER)
				$current_task/current_task_label.set_valign(VALIGN_CENTER)
				$current_task/current_task_label.rect_size.x = 800
				$current_task/current_task_label.rect_size.y = 20
				$current_task/current_task_label.text = chosen_task
				#$current_task/complete_task_button.set_align(HALIGN_CENTER)
				#$current_task/complete_task_button.set_valign(VALIGN_CENTER)
				$current_task/complete_task_button.rect_size.x = 800
				$current_task/complete_task_button.rect_size.y = 20
				$suggested_task/choose_task_button/Label.text = "Click to get another suggestion"
				task_suggestion = true
				$current_task/complete_task_button.connect("pressed", self, "_on_current_task_button_pressed")
				#remove the task from the txt-file
				tasks.remove(i)
				break
			else:
				$current_task/current_task_label.text = chosen_task
	print(tasks)
	
func _on_current_task_button_pressed():
	var completed_task = RichTextLabel.new()
	
	$completed_task.add_child(completed_task)
	$completed_task.get_children()[-1].bbcode_enabled = true
	$completed_task.get_children()[-1].rect_min_size.y = 20
	$completed_task.get_children()[-1].append_bbcode("[s]"+$current_task/current_task_label.text+"[/s]")
	
	$current_task/current_task_label.text = ""
	
func button_maker():
	pass
	
	
