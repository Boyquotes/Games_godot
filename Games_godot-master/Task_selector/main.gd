extends CanvasLayer

const STATE_FILEPATH = "user://task_state.json"
const TASKS_FILEPATH = "user://tasks.txt"
const NOTES_FILEPATH = "user://notes_tm.txt"

func _ready():
	load_task_state()
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func _on_add_task_button_pressed():
	var f = File.new()
	if not f.file_exists(TASKS_FILEPATH): return 
	f.open(TASKS_FILEPATH, File.READ)
	var tasks = f.get_as_text().split(",")
	tasks.push_back($add_task/add_task_prompt.text)
	f.open(TASKS_FILEPATH, File.WRITE)
	f.store_string(tasks.join(","))
	f.close()
	$add_task/add_task_prompt.text = ""
	
func _on_close_button_pressed():
	save_task_state()
	get_tree().quit()
	
func _on_choose_task_button_pressed():
	var chosen_task
	$end_task.visible = true
	
	if $current_task.text != "" and populate_tasks().size() > 1:
		chosen_task = random_task()
		while chosen_task == $current_task.text:
			chosen_task = random_task()
	elif populate_tasks().size() == 1:
		chosen_task = random_task()
	
	if chosen_task != null:
		$suggest_task/choose_task_button/Label.text = "Click to get another suggestion"
		$current_task.text = chosen_task
	else:
		$current_task.text = "no more tasks!"
		$end_task.visible = false
	
func _on_end_task_button_pressed():
	if $current_task.text == "": return
	end_task($current_task.text)
	delete_task($current_task.text)
	$current_task.text = "Task Done!"
	$end_task.visible = false
	
func _on_clear_button_pressed():
	var confirm_window = ConfirmationDialog.new()
	
	self.add_child(confirm_window)
	confirm_window.name = "confirm_window"
	$confirm_window.dialog_text = "do you really want to clear all completed tasks?"
	$confirm_window.rect_position = Vector2(342, 200)
	$confirm_window.connect("confirmed", self, "_on_task_deletion_confirm")
	$confirm_window.visible = true
	
func _on_task_deletion_confirm():
	for i in $completed_tasks/completed_list.get_children():
		$completed_tasks/completed_list.remove_child(i)
		i.queue_free()
		
func _on_delete_button_pressed():
	var confirm_delete_all_window = ConfirmationDialog.new()
	
	self.add_child(confirm_delete_all_window)
	confirm_delete_all_window.name = "confirm_delete_all_window"
	$confirm_delete_all_window.dialog_text = "do you really want to clear all current tasks?"
	$confirm_delete_all_window.rect_position = Vector2(342, 200)
	$confirm_delete_all_window.connect("confirmed", self, "_on_deletion_all_confirm")
	$confirm_delete_all_window.visible = true
	
func _on_deletion_all_confirm():
	var f = File.new()
	f.open(TASKS_FILEPATH, File.WRITE)
	f.close()
	$current_task.text = "no more tasks!"
	$end_task.visible = false
	
func _on_notes_button_pressed():
	OS.shell_open(ProjectSettings.globalize_path(NOTES_FILEPATH))

#------------------------------------------------------------------

func populate_tasks():
	var f = File.new()
	f.open(TASKS_FILEPATH, File.READ)
	var tasks = f.get_as_text().split(",", false)
	f.close()
	return tasks
	
func random_task():
	var tasks = populate_tasks()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return tasks[rand.randf_range(0, tasks.size())]
	
func end_task(task):
	var completed_task = RichTextLabel.new()
	$completed_tasks/completed_list.add_child(completed_task)
	$completed_tasks/completed_list.get_children()[-1].bbcode_enabled = true
	$completed_tasks/completed_list.get_children()[-1].rect_min_size.y = 20
	$completed_tasks/completed_list.get_children()[-1].append_bbcode("[s]"+task+"[/s]")

func delete_task(task):
	var f = File.new()
	f.open(TASKS_FILEPATH, File.READ)
	var tasks = f.get_as_text().split(",")
	f.open("TASKS_FILEPATH", File.WRITE)
	f.close()
#
	for i in tasks.size():
		if tasks[i] == task:
			tasks.remove(i)
			f.open(TASKS_FILEPATH, File.WRITE)
			f.store_string(tasks.join(","))
			f.close()
			break
	
func save_task_state():
	var completed_tasks = []
	for i in $completed_tasks/completed_list.get_children().size():
		completed_tasks.push_back($completed_tasks/completed_list.get_children()[i].text)
		
	var state = {
		"current_task": $current_task.text,
		"button_vis": $end_task.visible,
		"completed_tasks": completed_tasks
	}
	
	var f = File.new()
	f.open(STATE_FILEPATH, File.WRITE)
	f.store_line(to_json(state))
	f.close()
	
func load_task_state():
	var f = File.new()
	if not f.file_exists(STATE_FILEPATH): return
	f.open(STATE_FILEPATH, File.READ)
	var states = JSON.parse(f.get_as_text())
	
	$end_task.visible = states.result["button_vis"]
	$current_task.text = states.result["current_task"]
	for i in states.result["completed_tasks"]:
		end_task(i)
		
	f.close()
	
			
# todo: sub tasks
# todo: show all tasks (in program or new window)





