extends CanvasLayer

var task_suggestion = false
const state_filepath = "user://task_state.json"
const tasks_filepath = "user://tasks.txt"

func _ready():
	load_task_state()
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func _on_add_task_button_pressed():
	var f = File.new()
	if not f.file_exists(tasks_filepath): return
	f.open(tasks_filepath, File.READ)
	var tasks = f.get_as_text().split(",")
	tasks.push_back($add_task/add_task_prompt.text)
	f.open(tasks_filepath, File.WRITE)
	f.store_string(tasks.join(","))
	f.close()
	$add_task/add_task_prompt.text = ""
	
func _on_close_button_pressed():
	save_task_state()
	get_tree().quit()
	
func _on_choose_task_button_pressed():
	var chosen_task
	var tasks = populate_tasks()
	$end_task.visible = true
	
	if $current_task.text != "" and populate_tasks().size() > 1:
		chosen_task = random_task()
		while chosen_task == $current_task.text:
			chosen_task = random_task()
	else:
		chosen_task = random_task()
	
	for i in tasks.size():
		if tasks[i] == chosen_task:
			
			if task_suggestion == false:
				$current_task.text = chosen_task
				$suggest_task/choose_task_button/Label.text = "Click to get another suggestion"
				task_suggestion = true
				break
			else:
				$current_task.text = chosen_task
	
func _on_end_task_button_pressed():
	if $current_task.text == "": return
	end_task($current_task.text)
	delete_task($current_task.text)
	$current_task.text = ""
	$end_task.visible = false

#------------------------------------------------------------------

func populate_tasks():
	var f = File.new()
	f.open(tasks_filepath, File.READ)
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
	$completed_tasks.add_child(completed_task)
	$completed_tasks.get_children()[-1].bbcode_enabled = true
	$completed_tasks.get_children()[-1].rect_min_size.y = 20
	$completed_tasks.get_children()[-1].append_bbcode("[s]"+task+"[/s]")

func delete_task(task):
	var f = File.new()
	f.open(tasks_filepath, File.READ)
	var tasks = f.get_as_text().split(",")
	f.open("rtasks_filepath", File.WRITE)
	f.close()
#
	for i in tasks.size():
		if tasks[i] == task:
			tasks.remove(i)
			f.open(tasks_filepath, File.WRITE)
			f.store_string(tasks.join(","))
			f.close()
			break
	
func save_task_state():
	var completed_tasks = []
	for i in $completed_tasks.get_children().size():
		completed_tasks.push_back($completed_tasks.get_children()[i].text)
	completed_tasks.remove(0)
		
	var state = {
		"current_task": $current_task.text,
		"button_vis": $end_task.visible,
		"completed_tasks": completed_tasks
	}
	
	var f = File.new()
	f.open(state_filepath, File.WRITE)
	f.store_line(to_json(state))
	f.close()
	
func load_task_state():
	var f = File.new()
	if not f.file_exists(state_filepath): return
	f.open(state_filepath, File.READ)
	var states = JSON.parse(f.get_as_text())
	
	$end_task.visible = states.result["button_vis"]
	$current_task.text = states.result["current_task"]
	for i in states.result["completed_tasks"]:
		end_task(i)
		
	f.close()
	
	
			
# todo: sub tasks?
# todo: task notes
# todo: write to disk save files: current task, close task btn visibility, completed tasks
# todo: when first item is added to task_filepath the entry is started with an "," delimiter which causes an empty suggestion in populate_tasks
