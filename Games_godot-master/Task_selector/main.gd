extends CanvasLayer

var task_suggestion = false
const state_filepath = "user://task_state.json"
const tasks_filepath = "user://tasks.txt"

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
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
	var chosen_task
	var tasks = populate_tasks()
	$end_task.visible = true
	
	if $current_task.text != "":
		chosen_task = random_task()
		while chosen_task == $current_task.text:
			chosen_task = random_task()
	else:
		chosen_task = random_task()
	
	for i in tasks.size():
		if tasks[i] == chosen_task:
#			$end_task/end_task_button.connect("pressed", self, "_on_end_task_button_pressed")
			
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
	f.open("res://task_selector.txt", File.READ)
	var tasks = f.get_as_text().split(",")
	f.open("res://task_selector.txt", File.WRITE)
	f.close()
#
	for i in tasks.size():
		if tasks[i] == task:
			tasks.remove(i)
			f.open("res://task_selector.txt", File.WRITE)
			f.store_string(tasks.join(","))
			f.close()
			break
			
func _on_add_task_button_pressed():
	var f = File.new()
	f.open("res://task_selector.txt", File.READ)
	var tasks = f.get_as_text().split(",")
	tasks.push_back($add_task/add_task_prompt.text)
	f.open("res://task_selector.txt", File.WRITE)
	f.store_string(tasks.join(","))
	f.close()
	$add_task/add_task_prompt.text = ""
	
	
func _on_close_button_pressed():
	
	get_tree().quit()
	
func load_task_state():
	pass
	
func save_task_state():
	pass
	
			
# todo: sub tasks?
# todo: task notes
# todo: write to disk save files: current task, close task btn visibility, completed tasks

#
#------------------------------------------------------
#
#func load_highscore():
#	var file = File.new()
#	if not file.file_exists(filepath): return
#	file.open(filepath, file.READ)
#
#	var load_highscores = JSON.parse(file.get_as_text())
#
#	var loaded_highscores = load_highscores.result
#
#	if typeof(loaded_highscores) == TYPE_ARRAY:
#		var counter = 0
#		for i in loaded_highscores:
#			var j = current_highscores[counter]
#			var score = j.get_node("highscore_score")
#			var name = j.get_node("name")
#			name.text = str(i[0])
#			score.text = str(i[1])
#			counter += 1
#	else:
#		pass

#------------------------------------------------------
#
#func save_highscore():
#	saved_highscores = [
#			[$VBoxContainer/highscore_1/name.text, $VBoxContainer/highscore_1/highscore_score.text],
#			[$VBoxContainer/highscore_2/name.text, $VBoxContainer/highscore_2/highscore_score.text],
#			[$VBoxContainer/highscore_3/name.text, $VBoxContainer/highscore_3/highscore_score.text],
#			[$VBoxContainer/highscore_4/name.text, $VBoxContainer/highscore_4/highscore_score.text],
#			[$VBoxContainer/highscore_5/name.text, $VBoxContainer/highscore_5/highscore_score.text],
#	]
#
#	#C:\Users\David\AppData\Roaming\Godot\app_userdata\Asteroids
#
#	var file = File.new()
#	file.open(filepath, File.WRITE)
#	file.store_line(to_json(saved_highscores))
#	file.close()





