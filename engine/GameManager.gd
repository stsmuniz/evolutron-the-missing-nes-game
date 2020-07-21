extends Control

func _ready():
	Options.paused = false
	Options.pause_menu = false
	hide()

func _process(delta):
	
	if Options.pause_menu == true:
		show()
		$Pause/Control/Resume.grab_focus()
		Options.paused = true
		
	get_tree().paused = Options.paused


	if Input.is_action_just_pressed("start"):
		Options.pause_menu = !Options.pause_menu
		Options.paused = !Options.paused


func _on_Title_pressed():
	Options.pause_menu = false
	Options.paused = false
	get_tree().paused = Options.paused
	SceneChanger.change_scene("res://screens_menus/StartMenu.tscn", 0.1)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	Options.paused = false
	Options.pause_menu = false
	hide()
