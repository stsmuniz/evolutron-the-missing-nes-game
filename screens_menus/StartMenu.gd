extends Control

onready var optionPressed = false


func _ready():
	optionPressed = false
	Options.choose_music("menu")

func _unhandled_input(event):
	if Input.is_action_pressed("start"):
		$MenuContainer/StartButton.grab_focus()
		$PressStart.visible = false
		$MenuContainer.visible = true
		$AnimationPlayer.stop()
		PlayerStats.max_health = 3
		PlayerStats.health = 3
		PlayerStats.powerup_shot = false


func _on_StartButton_pressed():
	if optionPressed == false:
		optionPressed = true
		Options.game_sound("select_option")
		SceneChanger.change_scene("res://maps/lvl1.tscn")

func _on_OptionsButton_pressed():
	if optionPressed == false:
		optionPressed = true
		SceneChanger.change_scene("res://screens_menus/OptionsMenu.tscn", 0.1)


func _on_QuitButton_pressed():
	if optionPressed == false:
		optionPressed = true
		get_tree().quit()
